//
//  ViewModel.swift
//  NYCSAT
//
//  Created by sade on 8/10/24.
//

import Foundation

//ViewModel
public class ViewModel: ObservableObject {
  @Published var items = [Model]()
  @Published var scoreItems = [ScoreModel]()
  @Published var searchText = ""

  func loadData() {
    guard let urlTask = URL(string: url) else { return }

    URLSession.shared.dataTask(with: urlTask) { (data, res, err) in

      do {

        if let data = data {

          let result = try JSONDecoder().decode([Model].self, from: data)

          DispatchQueue.main.async {
            self.items = result
          }

        } else {
          print("No data")
        }
      } catch (let error) {
        print(error)
      }
    }.resume()
  }

  func loadScoreData() {
    guard let urlTaskk = URL(string: urll) else { return }

    URLSession.shared.dataTask(with: urlTaskk) { (data, res, err) in

      do {

        if let data = data {

          let result = try JSONDecoder().decode([ScoreModel].self, from: data)

          DispatchQueue.main.async {
            self.scoreItems = result
          }

        } else {
          print("No data")
        }
      } catch (let error) {
        print(error)
      }
    }.resume()
  }

  //search bar to filter schools once searched
  var filteredItems: [Model] {
    if searchText.isEmpty {
      return items
    } else {
      return items.filter { $0.school_name.lowercased().contains(searchText.lowercased()) }
    }
  }
  //this function takes in school name and returns the SAT scores associated with that school
  func scoreSchool(_ schoolName: String) -> ScoreModel? {
    //trim spaces and ignore case for comparison
    let cleanedSchoolName = schoolName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

    for score in scoreItems {
      let cleanedScoreSchoolName = score.schoolName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

      if cleanedSchoolName == cleanedScoreSchoolName {
        return score
      }
    }

    print("No match found for: \(schoolName)")
    return nil
  }
}
