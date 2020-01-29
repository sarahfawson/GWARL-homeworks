# You will be give a set of poll data called election_data.csv. 
# The dataset is composed of three columns: Voter ID, County, and Candidate. 
# Your task is to create a Python script that analyzes the votes and calculates each of the following:
    # The total number of votes cast
    # A complete list of candidates who received votes
    # The percentage of votes each candidate won
    # The total number of votes each candidate won
    # The winner of the election based on popular vote.
    
import os
import csv

# declare variables and dictionary
total_votes = 0
#candidate = []
candidate_votes = {}
popular_winner = 0

# import file
with open("election_data.csv", "r", newline="") as election_data:
    csv_reader = csv.reader(election_data,delimiter=",")
    
    # skip the first row with headers
    header = next(csv_reader)
    
    # iterate through the data in the csv file
    for row in csv_reader:
        
        # add to total votes calculation
        total_votes = total_votes + 1
        
        # finding each unique candidate AND counting each time they got a vote
        if row[2] not in candidate_votes:
            candidate_votes[row[2]] = 0
            
        candidate_votes[row[2]] = candidate_votes[row[2]] + 1 

# popular vote winner
popular_winner = max(candidate_votes, key = candidate_votes.get)
        
# print results
print("Election Results: ")        
print("----------------------------")
print(f"Total votes: {total_votes}")
print("----------------------------")

# loop through dictionary to print the votes and percentages for each candidate
for candidate in candidate_votes:
    percentage = int(candidate_votes[candidate]/total_votes * 100)
    print(f"{candidate}: {percentage}% ({candidate_votes[candidate]})")

# keep printing results
print("----------------------------")
print(f"Winner of the popular vote: {popular_winner}")


# NEEEEXXXXTTTTTTT......


# Output files into a txt file
output_file = "Election_Analysis_Summary.txt"

with open(output_file,"w") as file:
    
# print results to Election_Analysis_Summary txt file
    file.write("Election Results: ")
    file.write("\n")
    file.write("----------------------")
    file.write("\n")
    file.write(f"Total votes: {total_votes}")
    file.write("\n")
    file.write("----------------------")
    file.write("\n")
    # loop through dictionary to print the votes and percentages for each candidate
    for candidate in candidate_votes:
        percentage = int(candidate_votes[candidate]/total_votes * 100)
        file.write(f"{candidate}: {percentage}% ({candidate_votes[candidate]}) \n")

    # keep printing results
    file.write("----------------------")
    file.write("\n")
    file.write(f"Winner of the popular vote: {popular_winner}")
