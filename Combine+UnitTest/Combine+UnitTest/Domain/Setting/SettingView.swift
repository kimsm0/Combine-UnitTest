//
//  SettingView.swift
//  Combine+UnitTest
//
//  Created by kimsoomin_mac2022 on 3/18/24.
//

import SwiftUI

struct SettingView: View {
    @AppStorage(AppStorageType.Appearance) var appearance: Int = UserDefaults.standard.integer(forKey: AppStorageType.Appearance)
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appearanceController: AppearanceController
    @StateObject var settingViewModel: SettingViewModel
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(settingViewModel.sectionItems){ section in
                    Section {
                        ForEach(section.items){ setting in
                            Button(action: {
                                if let type = setting.item as? AppearanceType {
                                    appearanceController.changeAppearance(type)
                                    appearance = type.rawValue
                                }
                            }, label: {
                                Text(setting.item.label)
                                    .font(.system(size: 14))
                                    .foregroundColor(.bkText)
                            })
                        }
                    } header: {
                        Text(section.label)
                    }
                }
            }
            .navigationTitle("설정")
            .toolbar{
                Button {
                    dismiss()
                } label: {
                    Image("search_close")
                }
            }
        }
        .preferredColorScheme(appearanceController.appearance.colorScheme)
    }
}

#Preview {
    SettingView(settingViewModel: .init())
}
