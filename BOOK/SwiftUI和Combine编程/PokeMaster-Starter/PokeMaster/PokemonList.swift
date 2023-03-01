//
//  PokemonList.swift
//  PokeMaster
//
//  Created by WENBO on 2023/2/26.
//  Copyright © 2023 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
    @State var expandingIndex: Int?
    var body: some View {
        //        List(PokemonViewModel.all) { pokemon in
        //            PokemonInfoRow(model: pokemon, expanded: false)
        //        }
        
        ScrollView {
            LazyVStack {
                ForEach(PokemonViewModel.all) { pokemon in
                    PokemonInfoRow(model: pokemon, expanded: self.expandingIndex == pokemon.id)
                        .onTapGesture {
                            print("点击")
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.425, blendDuration: 0)) {
                                if self.expandingIndex == pokemon.id {
                                    self.expandingIndex = nil;
                                } else {
                                    self.expandingIndex = pokemon.id
                                }
                            }
                        }
                }
            }
        }
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList()
    }
}
