# Hidden Markov Model For Named Entity Recognition

This project contains an implementation for a Hidden Markov Model for Named Entity Recognition (NER) in MatLab. The parameters are learned from the labelled data and Viterbi decoding is performed for make predictions. 


## NER Dataset
A NER dataset from the CoNNL 2003 shared task has been provided in data.mat. The file data.mat contains:
    
    * train: Structure with the training data.
        1. *word_seqs*: Cell array with the word sequences.
        2. *tag_seqs*: Cell array with the tag sequences. Matching dimensions to *word_seqs*.

    * test: Test dataset. Same structure as the training dataset.