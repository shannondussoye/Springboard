suppressWarnings(library(dplyr))
suppressWarnings(library(tidyr))
setwd("~/R/Projects/Springboard/3. Data Wrangling/Exercise 1: Basic Data Manipulation")

# 0: Load the data in RStudio
data <- read.csv("refine_original.csv", sep = ",",stringsAsFactors = F) %>% tbl_df()
#rename col
colnames(data)[2] <- "product_c_n"

# 1: Clean up brand names
# Clean up the 'company' column, so all of the misspellings of the brand names are standardized. For example, 
#you can transform the values in the column to be: philips, akzo, van houten and unilever (all lowercase).
data$company <- tolower(data$company)
data$company %>% unique()
data$company <- gsub("phillips|phllips|phillps|fillips|phlips","philips",data$company)
data$company <- gsub("akz0|ak zo","akzo",data$company)
data$company <- gsub("unilver","unilever",data$company)

# 2: Separate product code and number
# Separate the product code and product number into separate columns 
#i.e. add two new columns called product_code and product_number, containing the product code and number respectively
data <- data %>% separate(product_c_n,into = c("product_code","product_num"),sep = "-")

 
# 3: Add product categories
# You learn that the product codes actually represent the following product categories:
# p = Smartphone
# v = TV
# x = Laptop
# q = Tablet
# In order to make the data more readable, add a column with the product category for each record.

data$product_category <- data$product_code 
data$product_category <-  gsub("p","Smartphone",data$product_category)
data$product_category <-  gsub("v","Tv",data$product_category) 
data$product_category <-  gsub("x","Laptop",data$product_category) 
data$product_category <-  gsub("q","Tablet",data$product_category) 
 
# 4: Add full address for geocoding
# You'd like to view the customer information on a map. In order to do that, the addresses need to be in a form 
# that can be easily geocoded. 
#Create a new column full_address that concatenates the three address fields (address, city, country), separated by commas.
data$full_address <- paste(data$address,data$city,data$country,sep = ",")


# 5: Create dummy variables for company and product category
# Both the company name and product category are categorical variables i.e. 
# they take only a fixed set of values. In order to use them in further analysis you need to create dummy variables. 
# Create dummy binary variables for each of them with the prefix company_ and product_ i.e.
#     Add four binary (1 or 0) columns for company: company_philips, company_akzo, company_van_houten and company_unilever
#     Add four binary (1 or 0) columns for product category: product_smartphone, product_tv, product_laptop and product_tablet

for (level in gsub(" ","_",unique(data$company))) {
  data[paste("company", level, sep = "_")] <- ifelse(data$company == level, 1, 0)
}

for (level in unique(data$product_category)) {
  data[paste("product", level, sep = "_")] <- ifelse(data$product_category == level, 1, 0)
}

# 6: Submit the project on Github
# Include your code, the original data as a CSV file refine_original.csv, 
#and the cleaned up data as a CSV file called refine_clean.csv.
write.csv(data,"refine_clean.csv",sep = ",")
