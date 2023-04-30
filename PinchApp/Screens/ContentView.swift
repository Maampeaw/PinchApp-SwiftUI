//
//  ContentView.swift
//  PinchApp
//
//  Created by Mark Amoah on 4/29/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    func resetImageState(){
        withAnimation(.spring()){
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage()->String{
        return pages[pageIndex - 1].imageName
    }
    var body: some View {
        NavigationView{
            ZStack{
                Color.clear
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y:2 )
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                    //tapGesture
                    .onTapGesture(count: 2) {
                        if imageScale == 1{
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        }else{
                            withAnimation(.spring()){
                                imageScale = 1
                            }
                        }
                        
                    }
                //Drag Gesture
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                withAnimation(.linear){
                                    imageOffset = value.translation
                                }
                            })
                            .onEnded({ value in
                                if imageScale <= 1{
                                    resetImageState()
                                }
                            })
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)){
                                    if imageScale >= 1 && imageScale <= 5{
                                        imageScale = value
                                    }else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            })
                            .onEnded({ _ in
                                if imageScale > 5{
                                    imageScale = 5
                                }else if imageScale <= 1{
                                    resetImageState()
                                }
                            })
                    )
                 
                
            }
            .navigationTitle("Pinch and Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                withAnimation(.linear(duration: 0.5)) {
                    isAnimating = true
                }
            }
            .overlay(infoPaneView(scale: imageScale, offset: imageOffset)
                     .padding(.horizontal)
                     .padding(.top, 30)
                     ,  alignment: .top)
            
            //Mark Controllers
            .overlay(
                Group{
                    HStack{
                        //Scale Down
                        Button{
                            withAnimation(.spring()){
                                if imageScale > 1{
                                    imageScale -= 1
                                }
                                if imageScale <= 1{
                                    resetImageState()
                                }
                            }
                        }label:{
                            ControlImageView(iconName: "minus.magnifyingglass")
                        }
                        //Reset
                        Button{
                            resetImageState()
                        }label:{
                            ControlImageView(iconName: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        //Scale up
                        Button{
                            if imageScale < 5{
                                imageScale += 1
                            }
                            if imageScale > 5{
                                imageScale = 5
                            }
                            
                        }label:{
                            ControlImageView(iconName: "plus.magnifyingglass")
                        }
                        
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    //end  of controls
                }
                    .padding(.bottom, 30),
                alignment: .bottom
                    
            )
            .overlay(
                HStack(spacing:12){
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut){
                                isDrawerOpen.toggle()
                            }
                        }
                    ForEach(pages) { page in
                        Image(page.thumbNailName)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = page.id
                                print("tapped")
                            }
                            
                    }
                Spacer()
                
                }.padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 230),
                alignment: .topTrailing
            )
           
        }//end of navigation view
        .navigationViewStyle(.automatic)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            
    }
}
