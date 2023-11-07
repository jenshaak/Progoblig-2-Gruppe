use context essentials2021
include image

#Lager arrays for hver pinne, hvor arrayene holder på verdiene til sirklene på pinnene
venstre-pinne = [array: 4, 3, 2, 1]
midt-pinne = [array: 0, 0, 0, 0]
hoyre-pinne = [array: 0, 0, 0, 0 ]

#Lager en array for hele hanoi-bordet, som inneholder arayene til pinnene.
hanoi-bord = [array: venstre-pinne, midt-pinne, hoyre-pinne]

#Henter ut nåværende sirkler på pinnene i hanoi-bordet
pinne1 = hanoi-bord.get-now(0)
pinne2 = hanoi-bord.get-now(1)
pinne3 = hanoi-bord.get-now(2)

#definerer de forskjellige sirklene, så vi slipper å skrive det inn hver gang vi vil tegne de.
pinne-sirkel = circle(15,"solid","black")
rosa-sirkel = circle(40,"solid", "pink")
lilla-sirkel = circle(60,"solid", "purple")
rod-sirkel = circle(80,"solid","red")
gronn-sirkel = circle(100,"solid","green")
bakgrunn = circle(100,"solid","transparent")
ingen-sirkel = circle(0,"solid", "transparent") 

#    | otherwise: ingen-sirkel
fun finn-sirkel(pinne :: Array, indeks :: Number):
  ask:
    | pinne.get-now(indeks) == 1 then: rosa-sirkel
    | pinne.get-now(indeks) == 2 then: lilla-sirkel
    | pinne.get-now(indeks) == 3 then: rod-sirkel
    | pinne.get-now(indeks) == 4 then: gronn-sirkel
    | pinne.get-now(indeks) == 0 then: ingen-sirkel
  end
end

#Tegner hanoi-tårnet. Bruker beside for å legge objekter ved siden av hverandre og overlay for å legge de oppå hverandre.
fun draw():
    beside(
      overlay(circle(15,"solid","black"),
      overlay(finn-sirkel(pinne1, 3),
        overlay(finn-sirkel(pinne1, 2),
          overlay(finn-sirkel(pinne1, 1),
            overlay(finn-sirkel(pinne1, 0),
              bakgrunn))))),
    
    beside(
        overlay(circle(15,"solid","black"),
        overlay(finn-sirkel(pinne2, 3),
          overlay(finn-sirkel(pinne2, 2),
            overlay(finn-sirkel(pinne2, 1),
              overlay(finn-sirkel(pinne2, 0),
                bakgrunn))))),
    
        overlay(circle(15,"solid","black"),
        overlay(finn-sirkel(pinne3, 3),
          overlay(finn-sirkel(pinne3, 2),
            overlay(finn-sirkel(pinne3, 1),
              overlay(finn-sirkel(pinne3, 0),
                bakgrunn)))))))
end




#Ma finne øverste sirkel på en pinne, fordi det er denne som kan bli flyttet. Hvis det ikke er noen sirkler på pinnen, returneres -1.
fun overste-sirkel(pinne :: Array) -> Number:
  ask:
    | pinne.get-now(3) == 1 then: 3
      
    | pinne.get-now(2) == 1 then: 2
    | pinne.get-now(2) == 2 then: 2
      
    | pinne.get-now(1) == 1 then: 1
    | pinne.get-now(1) == 2 then: 1
    | pinne.get-now(1) == 3 then: 1
      
    | pinne.get-now(0) == 1 then: 0
    | pinne.get-now(0) == 2 then: 0
    | pinne.get-now(0) == 3 then: 0
    | pinne.get-now(0) == 4 then: 0
    | otherwise: -1
  end
end



#La inn en tabell, med tre kolonner; Trekk, som nummer og sirkel og Posisjon som tekst.
var logg = table: Trekk :: Number, sirkel :: String, Flyttet-til :: String
end

#Legger inn hvilken sirkel som flyttes i tabellen.
fun sirkel-som-flyttes(nummer :: Number) -> String:
  ask:
    | nummer == 1 then: "rød"
    | nummer == 2 then: "grønn"
    | nummer == 3 then: "blå"
    | nummer == 4 then: "oransje"
  end
end

#Legger inn hvilken posisjon sirkelen flyttes til.
fun flyttes-til-pinne(pinne :: Array) -> String:
  ask:
    | pinne == pinne1 then: "venstre pinne"
    | pinne == pinne2 then: "pinne i midten"
    | pinne == pinne3 then: "høyre pinne"
  end
end

#Lager en variabel for antall trekk og en funksjon som registrerer de og legger de inn i tabellen.
var antall-trekk = 0
fun registrer-trekk(sirkel-nummer :: Number, Flyttet-til :: Array):
  block:
    antall-trekk := antall-trekk + 1
    row = logg.row(antall-trekk, sirkel-som-flyttes(sirkel-nummer), flyttes-til-pinne(Flyttet-til))
    logg := logg.add-row(row)
  end
end





#Bruker funksjonen move for å flytte den øverste sirkelen til en anned pinne. 
fun move(fra, til): 
  block:
    overste-sirkel-fra = overste-sirkel(fra)
    #Gir feilmelding til spiller når det ikke er sirkler å flytte.
    when overste-sirkel-fra == -1:
      raise("Her er det ingen sirkler å flytte!")
    end
    
    
    var til-pinne = 0 
    overste-sirkel-til = overste-sirkel(til) 
    when not(overste-sirkel-til == -1):
      til-pinne := overste-sirkel-til + 1
    end
    
    sirkel = fra.get-now(overste-sirkel-fra)
    neste-sirkel = if overste-sirkel-til == -1:
      0
    else:
      til.get-now(overste-sirkel-til)
    end
    mulig = ((neste-sirkel - sirkel) > 0) or (neste-sirkel == 0)
    when not(mulig):
      raise("Du kan ikke flytte sirkelen oppå en mindre sirkel")
     end
    
    #Måtte bruke set-now for at bildet skulle oppdateres til sirkelen i ny pinne.
    til.set-now(til-pinne, sirkel) 
    fra.set-now(overste-sirkel-fra, 0)
    registrer-trekk(sirkel, til)    
  end
  
end


#Regner ut om spilleren har vunnet. Når alle pinnene er på pinne3, blir den samlede verdien av de fire sirklene på pinnen følgende: 1+2+3+4=10.
fun Seier():
  full-pott = pinne3.get-now(0) + pinne3.get-now(1) + pinne3.get-now(2) + pinne3.get-now(3)
  fullfort = full-pott == 10
  fullfort
end

fun resultat() -> Table:
  block:
    logg
  end
end

#Lar spilleren gjøre trekk ved å skrive "play-move(pinneX, pinneX)". Lager et oppdatert hanoi-bilde etter hvert trekk spilleren gjør.
fun play-move(fra, til): 
  block:
    move(fra, til)
    
    nytt-hanoi = draw()
    
    #Sjekker om spilleren har vunnet, og printer i så fall en melding, som inneholder hvor mange trekk som har blitt gjort.
    fullfort = Seier()
    when fullfort:
      block:
        print("Gratulerer! Antall trekk du brukte: " + to-string(antall-trekk))
        print(" ")
        print("Skriv logg for å se alle trekkene du har gjort")
        print(" ")
      end
    end
    
    nytt-hanoi
  end
end

#Lagde en funksjon for oppstart av spillet for å enklere få med alle elementene i oppstarten.
fun start-spill():
  block:
    print(" ")
    print("Skriv play-move(pinneX, pinneY) for å flytte en sirkel fra en pinne til en annen.")
    print("For eksempel: play-move(pinne1, pinne2)")
    print(" ")
    print("Skriv logg for å se alle trekkene du har gjort")
    print(" ")
    print(" ")
    draw()
  end
end

start-spill()
