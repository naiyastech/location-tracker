//
//  LocationsView.swift
//  LocationTest
//
//  Created by Ian (US) on 11/05/2025.
//

import SwiftUI
import SwiftData

struct LocationDataView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    private var groupedItems: [Date: [Item]] {
        Dictionary(grouping: items, by: { $0.day })
    }
    
    @State private var exportedFileURL: URL?
    @State private var isExported: Bool = true
    @State private var isSheetPresented: Bool = false
    @State private var disclosureStates: [Date: Bool] = [:]
    
    var body: some View {
        
        if items.isEmpty {
            
            Text("No location data available.")
                .font(.title)
                .foregroundStyle(.secondary)
                .padding()
            
        } else {
            
            List {
                ForEach(groupedItems.keys.sorted(), id: \.self) { date in
                    NavigationLink {
                        LocationDateView(date: date, items: groupedItems[date] ?? [])
                    } label: {
                        let itemCount = groupedItems[date]?.count ?? 0
                        Text("\(date, format: Date.FormatStyle(date: .numeric, time: .omitted)) (\(itemCount))")
                    }
                }
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
            .navigationTitle("Location Data")
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
            let csvHeader = "Timestamp,Latitude,Longitude,Altitude,Country,State,City,Placemark\n" // CSV Header
            let csvRows = items.map { item in
                "\(item.timestamp),\(item.latitude),\(item.longitude),\(item.altitude),\(item.isoCountry ?? "XX"),\(item.state ?? ""),\(item.city ?? ""),\(item.placemark)\n"
            }
            return Data((csvHeader + csvRows.joined()).utf8)
        }.value
    }
    
    private func createTemporaryFileURL(with fileName: String) -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        return tempDirectory.appendingPathComponent(fileName)
    }
}

#Preview {
    LocationDataView()
        .modelContainer(for: Item.self, inMemory: true)
}
