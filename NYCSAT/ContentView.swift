//
//  ContentView.swift
//  NYCSAT
//
//  Created by sade on 8/10/24.
//
import SwiftUI
//click school names and show sat scores
//search bar at top
//unit test - check to see if correct response on api call

let url = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
let urll = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"


//School Model
struct Model: Decodable, Hashable {
  let school_name: String
}

//SAT Model
struct ScoreModel: Decodable, Hashable {
  let schoolName: String
  let satCriticalReadingAvgScore: String
  let satMathAvgScore: String
  let satWritingAvgScore: String

  enum CodingKeys: String, CodingKey {
    case schoolName = "school_name"
    case satCriticalReadingAvgScore = "sat_critical_reading_avg_score"
    case satMathAvgScore = "sat_math_avg_score"
    case satWritingAvgScore = "sat_writing_avg_score"
  }
}

struct ContentView: View {
  @ObservedObject var viewModel = ViewModel()

  var body: some View {
    NavigationView {
      VStack {
        //place search bar at top of vstack
        SearchBar(text: $viewModel.searchText)
        List(viewModel.filteredItems, id: \.self) { item in
          VStack(alignment: .leading) {
            DisclosureGroup(item.school_name) {
              if let score = viewModel.scoreSchool(item.school_name) {
                VStack(alignment: .leading) {
                  Text("Reading: \(score.satCriticalReadingAvgScore)")
                  Text("Math: \(score.satMathAvgScore)")
                  Text("Writing \(score.satWritingAvgScore)")
                }
              } else {
                Text("No SAT data available")
              }
            }
            .padding(.vertical, 5)
          }
        }
        .navigationBarTitle("NYC School Names")
      }

      .onAppear( perform: {
        viewModel.loadData()
        viewModel.loadScoreData()
      })
    }
  }
}

struct SearchBar: View {
  @Binding var text: String

  var body: some View {
    HStack {
      TextField("Search...", text: $text)
        .padding(7)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal, 10)
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
