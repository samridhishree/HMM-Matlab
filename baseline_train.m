
function [baseline_params] = baseline_train(state_seqs, obs_seqs, n, m)
    assert (length(state_seqs) == length(obs_seqs));

    c_A = zeros(n, m);
    seq_length = length(state_seqs);

    %% Your code goes here. Collecting the co-occurrence statistics.
    for i = 1:seq_length
    	word_i = obs_seqs{i};
    	tag_i = state_seqs{i};
    	for j = 1:length(word_i)
    		c_A(tag_i(:,j), word_i(:,j))++;
    	end
    end
    baseline_params.A = c_A ./ repmat(sum(c_A, 2), 1, m);
end
