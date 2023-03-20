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

let API_KEY = "05f1aaa4009ce4e3d030f68a16dd74bf7562bca1014a0e26f05bd5eba8ed85feaf65ef0080df58d9cc54cbaf57f273a69808e10d523b61ee423d9499f3ecf162c14102ec8cf017f631a8cbd63055e2e607794770b23fb6238aad09290526686e183522282abafb9e8ade2383f29b29b5674f6b242c474eccf34a3cde434a1b86"

import SwiftUI

struct ProductBrand: Hashable, Codable {
    let name: String
    let hero_blurb: String
}

struct ProductBrandContainer: Hashable, Codable {
    let id: Int
    let attributes: ProductBrand
}

struct ProductBrandData: Hashable, Codable {
    let data: ProductBrandContainer
}

struct ProductGroup: Hashable, Codable {
    let name: String
}

struct ProductGroupContainer: Hashable, Codable {
    let id: Int
    let attributes: ProductGroup
}

struct ProductGroupData: Hashable, Codable {
    let data: ProductGroupContainer
}

struct ProductFeature: Hashable, Codable {
    let name: String
    let description: String
    let main_body: String
}

struct ProductFeatureContainer: Hashable, Codable {
    let id: Int
    let attributes: ProductFeature
}

struct ProductFeaturesData: Hashable, Codable {
    let data: [ProductFeatureContainer]
}

struct ProductDimension: Hashable, Codable {
    let id: Int
    let depth: Double
    let height: Double
    let width: Double
    let weight: Double
    let unit_length: String
    let unit_weight: String
}

struct ProductImage: Hashable, Codable {
    let url: String
}

struct ProductAttributes: Hashable, Codable {
    let sku: String
    let description: String
    let long_description: String
    let brand: ProductBrandData
    let group: ProductGroupData
    let features: ProductFeaturesData
//    let images: [ProductImage]
}

struct Product: Hashable, Codable {
    let id: Int
    let attributes: ProductAttributes
}

struct ProductListData: Codable {
    let data: [Product]
}


class FetchModel: ObservableObject {
    @Published var products = [Product]()
    
    var urlLink: String
    
    init(urlLink: String) {
        self.urlLink = urlLink
    }
    
    func fetchData() {
        guard let url = URL(string: urlLink) else {
            return
        }
        var request = URLRequest(url: url)
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(API_KEY)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    print("Data: ")
                    print(data)
                    let decodedResponse = try JSONDecoder().decode(ProductListData.self, from: data)
                    DispatchQueue.main.async {
                        self.products = decodedResponse.data
                    }
                    return
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}


struct ContentView: View {
    @StateObject var fetchModel = FetchModel(urlLink:
        "http://localhost:1337/api/products/?populate=*&pagination[page]=1&pagination[pageSize]=10"
    )
    
    var body: some View {
        NavigationView {
            List(fetchModel.products, id: \.self) { product in
                HStack{
                    HStack{
                        Text(String(product.attributes.sku))
                            .font(.headline)
                        Text(String(product.attributes.description))
                    }
                    NavigationLink(
                        destination: VStack{
                            HStack{
                                Text(String(product.attributes.brand.data.attributes.name))
                                Text(product.attributes.sku)
                            }
                            HStack{
                                Text("Group: ")
                                Text(product.attributes.group.data.attributes.name)
                            }
                            //replace with "For feature in features"
                            HStack{
                                Text("Feature: ")
                                Text(product.attributes.features.data[0].attributes.name)
                            }
                        }, label: {Text("Label")})
                }
            }
            .navigationBarTitle("Products")
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
