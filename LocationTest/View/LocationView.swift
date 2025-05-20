//
//  LocationsView.swift
//  LocationTest
//
//  Created by Ian (US) on 11/05/2025.
//

import SwiftUI
import SwiftData

struct LocationView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var exportedFileURL: URL?
    @State private var isExported: Bool = true
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        
        if items.isEmpty {
            
            Text("No location data available.")
                .font(.title)
                .foregroundStyle(.secondary)
                .padding()
            
        } else {
            
            List {
                ForEach(items) { item in
                    NavigationLink {
                        LocationDetailsView(item: item)
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .sheet(isPresented: $isSheetPresented, content: {
                if let fileURL = exportedFileURL {
                    VStack(spacing: 0) {
                        HStack() {
                            Button("Cancel") {
                                isSheetPresented.toggle()
                            }
                            Spacer()
                            Text("locations.csv")
                                .bold()
                            Spacer()
                            ShareLink(item: fileURL) {
                                Text("Save")
                            }
                        }
                        QuickLookPreview(fileURL: fileURL)
                    }
                    .padding(.all, 20)
                } else if isExported == false {
                    Text("Export failed.")
                        .foregroundColor(.red)
                } else {
                    ProgressView("Generating export file...")
                }
            })
            .presentationDragIndicator(.visible)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Export") {
                        exportedFileURL = nil
                        exportToCSVAsync()
                    }
                }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func exportToCSVAsync() {
        isSheetPresented = true
        
        Task {
            let csvData = await generateCSV(from: items)
            let tempURL = createTemporaryFileURL(with: "locations.csv")
            
            do {
                try csvData.write(to: tempURL)
                exportedFileURL = tempURL
            } catch {
                print("Error exporting CSV: \(error)")
                isExported = false
            }
            
            // Update UI on the main thread
            await MainActor.run {
                
            }
        }
    }
    
    private func generateCSV(from items: [Item]) async -> Data {
        await Task.detached {
            var csvString = "Timestamp,Latitude,Longitude,Altitude,Placemark\n" // CSV Header
            for item in items {
                csvString += "\(item.timestamp),\(item.latitude),\(item.longitude),\(item.altitude),\(item.placemark)\n" // Append item data
            }
            return Data(csvString.utf8)
        }.value
    }
    
    private func createTemporaryFileURL(with fileName: String) -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        return tempDirectory.appendingPathComponent(fileName)
    }
}

#Preview {
    LocationView()
        .modelContainer(for: Item.self, inMemory: true)
}
