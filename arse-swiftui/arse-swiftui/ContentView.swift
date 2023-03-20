// //
// //  ContentView.swift
// //  arse-swiftui
// //
// //  Created by csuftitan on 3/18/23.
// //

// import SwiftUI
// import RealityKit

// struct ContentView : View {
//     var body: some View {
// //        ARViewContainer().edgesIgnoringSafeArea(.all)
//         text
//     }
// }

// struct ARViewContainer: UIViewRepresentable {
    
//     func makeUIView(context: Context) -> ARView {
        
//         let arView = ARView(frame: .zero)
        
//         // Load the "Box" scene from the "Experience" Reality File
//         let boxAnchor = try! Experience.loadBox()
        
//         // Add the box anchor to the scene
//         arView.scene.anchors.append(boxAnchor)
        
//         return arView
        
//     }
    
//     func updateUIView(_ uiView: ARView, context: Context) {}
    
// }


// yeah just leave the stuff above ig


import SwiftUI

struct SinglePokeman: Hashable, Codable {
    let name: String
    let weight: Int
}

struct Pokemon: Hashable, Codable {
    let name: String
    let url: String
}

struct PokemonListResponse: Codable {
    let results: [Pokemon]
}

class FetchModel: ObservableObject {
    @Published var pokemon = [Pokemon]()
    
    var urlLink: String
    
    init(urlLink: String) {
        self.urlLink = urlLink
    }
    
    func fetchData() {
        guard let url = URL(string: urlLink) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(PokemonListResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.pokemon = decodedResponse.results
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct ContentView: View {
    @StateObject var fetchModel = FetchModel(urlLink: "https://pokeapi.co/api/v2/pokemon?limit=100")
    
    var body: some View {
        NavigationView {
            List(fetchModel.pokemon, id: \.self) { pokemon in
                HStack{
                    Text(pokemon.name)
                        .font(.headline)
                    NavigationLink(destination: Text(pokemon.name), label: {Text("")})
                }
            }
            .navigationBarTitle("Pokedex")
            .onAppear {
                fetchModel.fetchData()
            }
        }
        
    }
}

// TODO: FIX THIS SHIT LATER

//struct PreviewItemView: View {
//    var newUrlLink: String
//    @StateObject var fetchModel: FetchModel
//
//    init(newUrlLink: String, fetchModel: FetchModel) {
//        self.newUrlLink = newUrlLink
//        self.fetchModel = FetchModel(urlLink: newUrlLink)
//    }
//
//    var body: some View {
//        List(fetchModel.pokemon, id: \.self) { pokemon in
//            VStack{
//                Text(pokemon.name)
//                Text(pokemon.weight)
//            }
//
//        }
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
