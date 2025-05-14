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
    @State private var isExported: Bool = false
    
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
            .sheet(isPresented: $isExported, content: {
                if let fileURL = exportedFileURL {
                    QuickLookPreview(fileURL: fileURL)
                        .padding(.all, 10)
                } else {
                    Text("File not available for preview")
                        .foregroundColor(.red)
                }
                    
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Export") {
                        exportToCSV()
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
    
    private func exportToCSV() {
        let csvData = generateCSV(from: items)
        let tempURL = createTemporaryFileURL(with: "locations.csv")
        
        do {
            try csvData.write(to: tempURL)
            exportedFileURL = tempURL
            isExported.toggle()
        } catch {
            print("Error exporting CSV: \(error)")
        }
    }
    
    private func generateCSV(from items: [Item]) -> Data {
        var csvString = "Timestamp,Latitude,Longitude,Altitude,Placemark\n" // CSV Header
        for item in items {
            csvString += "\(item.timestamp),\(item.latitude),\(item.longitude),\(item.altitude),\(item.placemark)\n" // Append item data
        }
        return Data(csvString.utf8)
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
