//
//  ContentView.swift
//  APIExample
//
//  Created by Luis on 3/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var quote : DataAPI?
    
    var body: some View {
        ZStack {
            Image("space")
                .resizable()
                //.scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                Group {
                    Text(quote?.content ?? "")
                        .font(.title)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.5)))
                        .padding(.bottom, 10)
                    Text(quote?.author ?? "")
                    Text("\(quote?.length ?? 0)")
                    Text(quote?.dateAdded ?? "")
                }
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 5)
                
                Spacer()
                
                Button(action: llamaUrl){
                    Image(systemName: "heart.fill")
                }
                .foregroundColor(.white)
                .font(.system(size: 25, weight: .heavy))
            }
            .zIndex(1)
        }
        .onAppear(perform: llamaUrl)
    }
    
    private func llamaUrl() {
            guard let url = URL(string: "https://api.quotable.io/random") else{return}
            
            //Creamos sesión de URL para pedir datos a la URL
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {return}
                //Si hemos obtenido JSON, tenemos que usar un decodificador para almacenarlo en nuestra variable datos, de tipo Datos.
                if let datosDecodificados = try? JSONDecoder().decode(DataAPI.self,from:data){
                    //El Decoder va a almacenar cada etiqueta de JSON en nuestro struct
                    //Asignamos la info decodificada a nuestra variable de estado
                    //Lo hacemos desde el hilo principal, con DispatchQueue
                        DispatchQueue.main.async {
                            self.quote = datosDecodificados
                        }
                    }
                
            }.resume()
    }
}




struct DataAPI : Decodable {
    var content : String
    var author : String
    var length : Int
    var dateAdded : String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
