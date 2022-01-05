/*
  ClassMarks.swift
  
  By Zefeng Wang
  Created 2021-12-12
   
  This program reads both the students.txt and assignmets.txt files and 
  writes the information in csv file in a table format
*/

// import Foundation module
import Foundation

// Format all of the data like a table
func format( stuArray: [String], assignArray: [String]) -> [[String]] {

	// Add "Student" to header
	var array = [[String]]()
	array.append(["Student"] + assignArray)

	// Creates the data for each row of the table
	for row in 0..<stuArray.count {
		var marks = [String]()
		for col in 0..<array[0].count {
			if col == 0 {
				marks.append(stuArray[row])
			} else {
				marks.append(String(generateMarks() * 10 + 75))
			}
		}
		array.append(marks)
	}
	return array
}

// Generates random marks with a mean of 75 and a SD of 10 per student
func generateMarks() -> Double {
	var nextNextGaussian: Double? = {
    		srand48(Int.random(in: 0...100))
    		return nil
	}()
	if let gaussian = nextNextGaussian {
		nextNextGaussian = nil
		return gaussian
	} else {
		var value1, value2, sum: Double
		repeat {
			value1 = 2 * drand48() - 1
			value2 = 2 * drand48() - 1
			sum = pow(value1, 2) + pow(value2, 2)
		} while sum >= 1 || sum == 0

		let multiplier = sqrt(-2 * log(sum)/sum)
		nextNextGaussian = value2 * multiplier
		return value1 * multiplier
	}
}

// Reads information in both files as arrays
let students = try String(contentsOfFile: "/home/ubuntu/environment/files/Unit1-07/students.txt")
let stuArray = students.components(separatedBy: "\n").filter { $0 != "" }

let assignments = try String(contentsOfFile: "/home/ubuntu/environment/files/Unit1-07/assignments.txt")
let asArray = assignments.components(separatedBy: "\n").filter { $0 != "" }

let markArray = format(stuArray: stuArray, assignArray: asArray)

// Clears the file
let text = ""
do {
	try text.write(to: URL(fileURLWithPath: "marks.csv"), atomically: false,
							encoding: .utf8)
} catch {
	print(error)
}

// Display the data in the CSV file
if let fileWriter = try? FileHandle(forUpdating: URL(fileURLWithPath: "marks.csv")) {
	for array in markArray {
		let arrayString = array.joined(separator: " ") + "\n"
		fileWriter.seekToEndOfFile()
		fileWriter.write(arrayString.data(using: .utf8)!)
	}

	fileWriter.closeFile()
}
