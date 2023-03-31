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

let API_KEY = "dbfec22f11fe4f30964d531c325f0c279782e7fdee83894e8f746e7b89f4b2aca4c1f912c42707057e93a9e3d0a5b9fd694d32e2e6c328ac071072f187358b0046b857d6e48e3dd9f092cfab2d162cdb6525fab7cbeac07c40d9947fcf225ddc36e2c2b952e464cec1affc8cd9c7703833c2ebfed23ac5306b37878cc890f018"

import SwiftUI

struct ProductBrand: Hashable, Codable {
    let name: String
    let hero_blurb: String?
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

struct ProductImageAttributes: Hashable, Codable {
    let url: String?
}

struct ProductImageData: Hashable, Codable {
    let id: Int
    let attributes: ProductImageAttributes?
}

struct ProductImage: Hashable, Codable {
    let data: [ProductImageData]?
}

struct ProductAttributes: Hashable, Codable {
    let sku: String
    // Uncomment attributes and make sure they work
//    let description: String
//    let long_description: String
//    let brand: ProductBrandData
//    let group: ProductGroupData
//    let features: ProductFeaturesData
    let images: ProductImage?
}

struct Product: Hashable, Codable {
    let id: Int
    let attributes: ProductAttributes
}

struct ProductListData: Codable {
    let data: [Product]
}


class FetchProductListModel: ObservableObject {
    @Published var products = [Product]()
    
    var productListURL: String
    
    var baseURL: String
    
    init(productListURL: String, baseURL: String) {
        self.productListURL = productListURL
        self.baseURL = baseURL
    }
    
    
    func fetchData() {
        guard let url = URL(string: baseURL + productListURL) else {
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

//struct SwapperView: View {
//
//    @State var enableARMode = false
//
//    var body: some View{
//        return Group {
//            if enableARMode {
//                ARView()
//            }
//            else {
//                ContentView(enableARMode: $enableARMode)
//            }
//        }
//    }
//}

struct ContentView: View {
    @StateObject var productListModel = FetchProductListModel(productListURL:
                                                "/api/products/?populate=*&pagination[page]=1&pagination[pageSize]=10", baseURL: "http://localhost:1337"
    )
    
    func ConcatURL(listOfStrings: [String]) -> URL {
        var s: String = ""
        for str in listOfStrings {
            s += str
        }
        return URL(string: s)!
    }
    
    func GimmyFirstImage(product: Product) -> String {
        
        guard
            let imageURL = product.attributes.images?.data?[0].attributes?.url as? String
        else { return "/uploads/image_processing20200516_26875_cx3ies_705a5e16b1.png" }
        
        return imageURL
        
        
    }
    
    //@Binding var enableARMode : Bool
    
    var body: some View {
        NavigationView {
            List(productListModel.products, id: \.self) { product in
                HStack{
                    NavigationLink(
                        destination: VStack{
                            HStack{
                                //Display SKU
                            }
                            HStack{
                                Text("Group: ")
                                // Text(product.attributes.group.data.attributes.name)
                            }
                            //replace with "For feature in features"
                            /*
                            HStack{
                                Text("Feature: ")
                                Text(product.attributes.features.data[0].attributes.name)
                            }
                             */
                        }, label: {VStack{
                            
                            AsyncImage(url: ConcatURL(listOfStrings: [productListModel.baseURL, GimmyFirstImage(product: product)]))
                            { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable().aspectRatio(contentMode: .fit)
                                case .failure(let error):
                                    Text("Failed to Load: ").foregroundColor(.red)
                                case .empty:
                                    Text("loading......")
                                @unknown default:
                                    Text("loading...")
                                }
                            }
                                       Text(String(product.attributes.sku))
                                .font(.headline)
    //                        Text(String(product.attributes.description))
                        }})
                }
            }
            .navigationBarTitle("Products")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("AR Mode") {
                        ARCameraView()
                    }
                    
                }
            }
            .onAppear {
                productListModel.fetchData()
            }
        }
        
        
    }
}

import ARKit
import RealityKit

struct ARCameraView : UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeUIView(context: Context) -> some UIView {
        
        let view = ARView()
        
        let session = view.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        session.run(config)
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = session
        coachingOverlay.goal = .horizontalPlane
        view.addSubview(coachingOverlay)
        
        #if DEBUG
        view.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
        #endif
        
        return view
    }
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}

