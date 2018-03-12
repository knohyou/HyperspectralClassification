function Feature_Standardize = Feature_Stand(Feature)
Feature_Standardize = (Feature - mean(Feature))./std(Feature);
end