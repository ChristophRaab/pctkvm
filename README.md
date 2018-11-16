***Repository for PCTKVM from:

[1]Raab, Christoph ; Schleif, Frank-Michael: Transfer learning for the probabilistic classification vector machine. In: Gammerman, A. ; Vovk, V. ; Luo, Z. ; Smirnov, E. ; Peeters, R. (Hrsg.): Proceedings of the Seventh Workshop on Conformal and Probabilistic Prediction and Applications, Proceedings of Machine Learning Research. Bd. 91 : PMLR, 2018, S. 187–200
http://proceedings.mlr.press/v91/raab18a.html

***Repository for the Master thesis 'Integration of transfer learning into the Probabilistic Classification Vector Machine'***

This repository contains source code.

* It is divided into three subfolders:

   * The folder code contains MatLab files for the PCKTVM and every other Transfer Learning solutions which are used in the study. Furthermore, it contains the supplementary source code for visualizing results and datasets, calculating divergencies, etc.

   * The folder data contains the datasets which are used in the study. It uses the Reuters-21578 dataset for text classification. 
The image dataset contains images from the datasets office and Caltech-256. Furthermore, the 20-Newsgroup, dataset which is only used for testing the RT-PCVM

   * The folder result contains every file-output of any script/function in folder code. The results of the tests, divergences, etc. are saved in this folder. The result is divided into test types: FiveTwo, which contains the result of the classifier based on a 5x2 data sampling. Average, which contains the result of the classifier based on the whole dataset.

* Code: 
    * PCTKVM
    * PCTKVM_ThetaEst: Same folder as PCTKVM
    * PCTKVM_TKL_TO: PCVM with simple integration of TKL to demonstrate the theta optimization issue
    * PCVM 
    * SVM (LibSVM)
    * TKL
    * TCA
    * JDA
    * GFK
    * First version of RT-PCVM: Not included in any results
* Data:
   * Reuters
   * 20Newsgroup
   * OfficeCaltech
* Result:
   * Top level: Aggregated results
   * average: Results of test-type average
   * fivetwo: Results of test-type fivetwo

