//
//  urlView.swift
//  Desafio07
//
//  Created by Turma02-1 on 19/09/25.
//

import SwiftUI
import Foundation

class apiGET: ObservableObject {
    @Published var remedios: [Remedio] = []
    func fetch(){
        guard let url = URL(string:"http://127.0.0.1:1880/remedioGET")else{
            return
        }
        let task=URLSession.shared.dataTask(with:url){[weak self] data, _, error in
            guard let data=data, error==nil else{
                return
            }
            do{
                let parsed = try JSONDecoder().decode([Remedio].self, from:data)
                print("--- DADOS VINDOS DO BANCO --- \n", parsed, "\n --- FIM DOS DADOS ---")
                DispatchQueue.main.async{
                    self?.remedios = parsed
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}
