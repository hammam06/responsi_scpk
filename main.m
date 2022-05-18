dataset = readtable("dataset.xlsx")

%pricevalue
price1 = dataset.Price <= 2300;
dataset.PriceValue(price1) = 3;

price2 = dataset.Price <= 3300 & dataset.Price > 2300;
dataset.PriceValue(price2) = 2;

price3 = dataset.Price <= 4300 & dataset.Price > 3300;
dataset.PriceValue(price3) = 1;

%distance value
distance1 = dataset.Distance <= 5;
dataset.DistanceValue(distance1) = 4;

distance2 = dataset.Distance <= 15 & dataset.Distance > 5;
dataset.DistanceValue(distance2) = 3;

distance3 = dataset.Distance <= 25 & dataset.Distance > 15;
dataset.DistanceValue(distance3) = 2;

distance4 = dataset.Distance <= 36.6 & dataset.Distance > 25;
dataset.DistanceValue(distance4) = 1;

%cleanlinessvalue
clean1 = dataset.Cleanliness <= 5;
dataset.CleanValue(clean1) = 1;

clean2 = dataset.Cleanliness <= 10 & dataset.Cleanliness > 5;
dataset.CleanValue(clean2) = 2;

%valueformoney
value1 = dataset.Value <= 5;
dataset.MoneyValue(value1) = 1;

value2 = dataset.Value <= 10 & dataset.Value > 5;
dataset.MoneyValue(value2) = 2;


datasetSAW = [dataset.PriceValue
    dataset.DistanceValue
    dataset.CleanValue
    dataset.MoneyValue];

weightCriteria = [1, 4, 2, 3];
weightCriteria = weightCriteria ./ sum(weightCriteria);
typeCriteria = ["COST", "COST", "BENEFIT", "BENEFIT"];

[rowLength, columnLength] = size(datasetSAW);

nomarlizationMatrix = zeros(rowLength, columnLength);
for j = 1:columnLength
    if typeCriteria(j) == "BENEFIT"
        normalizationMatrix(:, j) = datasetSAW(:, j) ./ max(datasetSAW(:, j));
    else
        normalizationMatrix(:, j) = min(datasetSAW(:, j)) ./ datasetSAW(:, j);
    end
end

resultMatrix = zeros(rowLength, 1);
for i = 1:rowLength
    resultMatrix(i) = sum(weightCriteria * normalizationMatrix(i, :));
end

dataset.Result = resultMatrix;
