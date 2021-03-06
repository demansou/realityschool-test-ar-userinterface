//
//  BrowseView.swift
//  test-ar-userinterface
//
//  Created by Daniel Mansour on 12/9/21.
//

import SwiftUI

struct BrowseView: View {
    @Binding var showBrowse: Bool
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                // GridViews for thumbnails
                RecentsGrid(showBrowse: $showBrowse)
                ModelsByCategoryGrid(showBrowse: $showBrowse)
            }
            .navigationBarTitle(Text("Browse"), displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showBrowse.toggle()
                }) {
                    Text("Done").bold()
                })
        }
    }
}

struct RecentsGrid: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse: Bool
    
    var body: some View {
        if !self.placementSettings.recentlyPlaced.isEmpty {
            HorizontalGrid(showBrowse: $showBrowse, title: "Recents", items: self.getRecentsUniqueOrdered())
        }
    }
    
    func getRecentsUniqueOrdered() -> [Model] {
        var recentsUniqueOrderedArray: [Model] = []
        var modelNameSet: Set<String> = []
        
        for model in self.placementSettings.recentlyPlaced.reversed() {
            if !modelNameSet.contains(model.name) {
                recentsUniqueOrderedArray.append(model)
                modelNameSet.insert(model.name)
            }
        }
        
        return recentsUniqueOrderedArray
    }
}

struct ModelsByCategoryGrid : View {
    @EnvironmentObject var viewModel: ModelsViewModel
    @Binding var showBrowse: Bool

    var body: some View {
        VStack {
            ForEach(ModelCategory.allCases, id: \.self) { category in
                // Only display grid if category contains items
                if let modelsByCategory = self.viewModel.models.filter( { $0.category == category }) {
                    HorizontalGrid(showBrowse: $showBrowse, title: category.label, items: modelsByCategory)
                }
            }
        }
    }
}

struct HorizontalGrid: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse: Bool
    var title: String
    var items: [Model]
    private let gridItemLayout: [GridItem] = [GridItem(.fixed(150))]
    
    var body: some View {
        Separator()
        VStack(alignment: .leading) {
            Text(self.title)
                .font(.title2)
                .bold()
                .padding(.leading, 22)
                .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItemLayout, spacing: 30) {
                    ForEach(0..<self.items.count, id: \.self) { index in
                        let model = items[index]
                        
                        ItemButton(model: model) {
                            model.asyncLoadModelEntity { completed, error in
                                if completed {
                                    self.placementSettings.selectedModel = model
                                }
                            }
                            self.placementSettings.selectedModel = model
                            print("BrowseView: selected \(model.name) for placement.")
                            self.showBrowse = false
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 10)
                }
            }
        }
    }
}

struct ItemButton: View {
    @ObservedObject var model: Model
    let action: () -> Void
    
    var body : some View {
        Button(action: {
            self.action()
        }) {
            Image(uiImage: self.model.thumbnail)
                .resizable()
                .frame(minWidth: 0, maxWidth: 150, minHeight: 0, maxHeight: 150)
                .aspectRatio(1/1, contentMode: .fit)
                .background(Color(UIColor.secondarySystemFill))
                .cornerRadius(8.0)
        }
    }
}

struct Separator: View {
    var body: some View {
        Divider()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}
