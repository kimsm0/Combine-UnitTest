//
//  RecentSearchView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/18/24.
//

import SwiftUI

struct RecentSearchView: View {
    @Environment (\.managedObjectContext) var objectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date)]) var results: FetchedResults<SearchResult>
    
    var body: some View {
        VStack(spacing: 0){
            
            HStack{
                Text("최근 검색어")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.bkText)
                    .padding(.vertical, 54)
                Spacer()
            }
            
            
            if results.isEmpty {
                searchEmtpyView
            }else {
                ScrollView{
                    LazyVStack {
                        ForEach(results, id: \.self) { result in
                            HStack {
                                Text(result.name ?? "")
                                    .font(.system(size: 14))
                                    .foregroundColor(.bkText)
                                
                                Spacer()
                                
                                Button(action: {
                                    objectContext.delete(result)
                                    try? objectContext.save()
                                }, label: {
                                    Image("search_close")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                })
                            }
                        }
                    }
                }
            }
            Spacer()
            
        }.padding(.horizontal, 30)
    }
    
    var searchEmtpyView: some View {
        Text("검색 내역이 없습니다.")
            .font(.system(size: 10))
            .foregroundColor(.greyDeep)
            .padding(.vertical, 54)
    }
}

#Preview {
    RecentSearchView()
}
