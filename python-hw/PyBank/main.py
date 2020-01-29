# Your task is to create a Python script that analyzes the records to calculate each of the following:
    # The total number of months included in the dataset
    # The total net amount of "Profit/Losses" over the entire period
    # The average change in "Profit/Losses" between months over the entire period
    # The greatest increase in profits (date and amount) over the entire period
    # The greatest decrease in losses (date and amount) over the entire period

import os
import csv

# create lists and variables to store values
total_months = []
profits_or_losses = 0
monthly_change = []
previous_month_pnl = 0

# Open csv file
# budgetdata_csv = "budget_data.csv"

with open("budget_data.csv", "r", newline="") as budget_data:
    csv_reader = csv.reader(budget_data,delimiter=",")
    
    # skip the first row with headers
    header = next(csv_reader)
    
    # iterate through the data in the csv file
    for row in csv_reader:
        
        # append your lists to add months and total values
        total_months.append(row[0])
        profits_or_losses = profits_or_losses + (int(row[1]))
        
        #compare column b values to see monthly change in pnl value
        if len(total_months) != 1:
            monthly_change.append(int(row[1])-previous_month_pnl)
            previous_month_pnl = int(row[1])
        
# print results with code
print("Summary: ")
print("---------------")
print(f"Total months: {len(total_months)}")
print("Total profits or losses: " + str(profits_or_losses))
print("Average change in profits/losses between months: " + str((sum(monthly_change))/len(monthly_change)))
print("Greatest increase in profits: " + str(max(monthly_change)))
print("Greatest decrease in losses: " + str(min(monthly_change)))

# NEEEEXXXXTTTTTTT......

# Output files into a txt file
output_file = "Budget_Analysis_Summary.txt"

with open(output_file,"w") as file:
    
# print results to Financial_Analysis_Summary txt file
    file.write("Summary: ")
    file.write("\n")
    file.write("---------------")
    file.write("\n")
    file.write(f"Total months: {len(total_months)}")
    file.write("\n")
    file.write("Total profits or losses: " + str(profits_or_losses))
    file.write("\n")
    file.write("Average change in profits/losses between months: " + str((sum(monthly_change))/len(monthly_change)))
    file.write("\n")
    file.write("Greatest increase in profits: " + str(max(monthly_change)))
    file.write("\n")
    file.write("Greatest decrease in losses: " + str(min(monthly_change)))
