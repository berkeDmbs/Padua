//
//  DetailView.swift
//  Padua
//
//  Created by Berke Demirbaş on 23.04.2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> WKWebView  {
        let wkwebView = WKWebView()
        wkwebView.navigationDelegate = context.coordinator
        wkwebView.load(URLRequest(url: url))
        return wkwebView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        init(_ parent: WebView) {
            self.parent = parent
        }
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
    }
}

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @State var store: [Resto]
    @State private var isEditOn = false
    @State var restoIns: Resto
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack{
            VStack {
                Text(restoIns.desc)
                    .padding()
                ZStack{
                    WebView(url: URL(string: "\(restoIns.link)")!, isLoading: $isLoading).edgesIgnoringSafeArea(.bottom)
                    if isLoading {
                        ProgressView()
                    }
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    isEditOn.toggle()
                }, label: {
                    Text("Edit")
                })
            }
        }
        .sheet(isPresented: $isEditOn){
            VStack{
                Form {
                    TextField(text: $restoIns.name) {
                        Text("\(restoIns.name)")
                    }
                    Text("Link: \(restoIns.link)").foregroundStyle(.secondary)
                
                    Stepper("Price: \(restoIns.price)", value: $restoIns.price, in: 1...5)
                    Stepper("Rating: \(restoIns.rating)", value: $restoIns.rating, in: 1...5)
                    TextEditor(text: $restoIns.desc)
                    
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                            Text("Done").foregroundStyle(.white)
                        }
                    }).padding(.vertical)
                }
            }
        }
        .navigationTitle("\(restoIns.name)")
        .navigationBarTitleDisplayMode(.inline)
       
    }
}
