
function [hmm_params] = hmm_train(state_seqs, obs_seqs, n, m, alpha_obs, alpha_trans)

    assert (length(state_seqs) == length(obs_seqs));

    % Initialization of the tables for the counts.
    c_B = zeros(n+2, n+2);
    c_A = zeros(n, m);

    %% Your code goes here. Collect the statistics from the data.
    cTrans = zeros(n+2, n+2);
    c_i = zeros(1,n+2);
    c_obs = zeros(n, m);
    seq_length = length(state_seqs);

    % Counts
    for i = 1:seq_length
        word_i = obs_seqs{i};
        tag_i = state_seqs{i};
        cTrans(n+1, tag_i(1,1))++;
        for j = 1:length(word_i)
            c_obs(tag_i(:,j), word_i(:,j))++;
            c_i(1, tag_i(:,j))++;
            if (j < length(word_i))
                cTrans(tag_i(:,j), tag_i(:,j+1))++;
            end
        end
        cTrans(tag_i(:,length(word_i)), n+2)++;
    end

    % Estimation
    %for i = 1:n
     %   c_B(i,:) = cTrans(i, :) ./ c_i(1, i);
      %  c_B(i, n+2) = cTrans(i, n+2) / c_i(1, i);
    %end

    %c_B(n+1, :) = cTrans(n+1, :) ./ seq_length;

    %for i = 1:n
     %   c_A(i,:) = c_obs(i,:) ./ c_i(1,i);
    %end
    c_B = cTrans;
    c_A = c_obs;

    % Adding smoothing.
    c_B(1:n+1, 1:n) = c_B(1:n+1, 1:n) + alpha_trans;
    c_B(1:n, n+2) = c_B(1:n, n+2) + alpha_trans;
    c_A = c_A + alpha_obs;

    % The sum of the transitions out of each of the states.
    c_trans = sum(c_B, 2);


    hmm_params.B = c_B ./ repmat(c_trans, 1, n + 2);
    hmm_params.A = c_A ./ repmat(sum(c_A, 2), 1, m);
    %hmm_params.c_A = c_A;
    %hmm_params.c_trans = c_trans;
end