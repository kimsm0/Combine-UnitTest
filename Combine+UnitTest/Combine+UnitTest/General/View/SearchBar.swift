//
//  SearchButton.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/18/24.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    @Binding var shouldBecomeFirstResponde: Bool
    var tabbedSearchButton: (()-> Void)?
    
    init(text: Binding<String>, shouldBecomeFirstResponde: Binding<Bool>, tabbedSearchButton: (()-> Void)?) {
        self._text = text
        self._shouldBecomeFirstResponde = shouldBecomeFirstResponde
        self.tabbedSearchButton =  tabbedSearchButton
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ searchBar: UISearchBar, context: Context) {
        updateSearchText(searchBar, context: context)
        updateBecomeFirstResponder(searchBar, context: context)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, 
                    shouldBecomeFirstResponde: $shouldBecomeFirstResponde,
                    tabbedSearchButton: tabbedSearchButton)
    }
    
}

extension SearchBar {
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        @Binding var shouldBecomeFirstResponde: Bool
        var tabbedSearchButton: (()-> Void)?
        
        init(text: Binding<String>,
             shouldBecomeFirstResponde: Binding<Bool>,
             tabbedSearchButton: (()-> Void)?) {
            self._text = text
            self._shouldBecomeFirstResponde = shouldBecomeFirstResponde
            self.tabbedSearchButton = tabbedSearchButton
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.text = searchText
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.shouldBecomeFirstResponde = true
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            self.shouldBecomeFirstResponde = false 
        }
        
        func setSearchBarText(_ searchBar: UISearchBar, text: String){
            searchBar.text = text
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            tabbedSearchButton?()
        }
    }
    
}
extension SearchBar {
    private func updateBecomeFirstResponder(_ searchBar: UISearchBar, context: Context){
        guard searchBar.canBecomeFirstResponder else { return }
        
        DispatchQueue.main.async {
            if shouldBecomeFirstResponde {
                guard !searchBar.isFirstResponder else { return }
                searchBar.becomeFirstResponder()
            }else{
                guard searchBar.isFirstResponder else { return }
                searchBar.resignFirstResponder()
            }
        }
    }
    
    private func updateSearchText(_ searchBar: UISearchBar, context: Context) {
        context.coordinator.setSearchBarText(searchBar, text: text)
    }
}
