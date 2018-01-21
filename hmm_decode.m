
function [pred_state_seqs] = hmm_decode(hmm_params, obs_seqs)
    % Working directly in log domain, as it is more numerically stable.
    log_B = log(hmm_params.B);
    log_A = log(hmm_params.A);
    [n, m] = size(log_A); 

    pred_state_seqs = cell(1, length(obs_seqs));

    for k = 1:length(obs_seqs)
        word_i = obs_seqs{k};
        Tk = length(word_i);

        pred_st_seq = zeros(1, Tk);

        % Tables for keeping the scores and backpointers.
        scores = zeros(n, Tk);
        back_pts = zeros(n, Tk);

        % Base Case
        B_start = log_B(n+1, :);
        B_start = B_start(1:length(B_start)-2);
        temp_score = transpose(B_start) .+ log_A(:, word_i(:,1));
        scores(:,1) = temp_score;
        [val, idx] = max(scores(:,1));
        back_pts(:, 1) = (1:n);

        %Recursion
        for t = 1:Tk-1
            word_t = word_i(:,t+1);
            for j = 1:n
                B_temp = log_B(:,j);
                B_temp = B_temp(1:length(B_temp)-2);
                temp_score = scores(:,t) .+ B_temp .+ log_A(j, word_t);
                [val1, idx1] = max(temp_score);
                scores(j,t+1) = val1;
                back_pts(j,t+1) = idx1;
            end
        end
        
        %scores
        temp_score = scores(:, Tk) .+ log_B(:, n+2)(1:length(log_B)-2);
        [val, max_idx] = max(temp_score);
        pred_st_seq(1, Tk) = max_idx;
        i = Tk-1;

        while(i >= 1)
            next_idx = back_pts(max_idx, i+1);
            pred_st_seq(1, i) = next_idx;
            max_idx = next_idx;
            i--;
        end

        pred_state_seqs{k} = pred_st_seq;
    end
end

