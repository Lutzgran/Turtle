
#uses the first letter of a direction and the distance it will travle

local function ETurn(direction_letter, distance)
  
  if direction_letter = h
    for i = distance,1,-1
      turtle.turnRight()
  elseif direction_leter = l
    for i = distance,1,-1
      turtle.turnLeft()
  else
    return "direction letter needs to be h or l"
end

local function EMove(direction_letter, distance)

    if direction_letter = f
      for i = distance,1,-1
        turtle.forward()
        
    elseif direction_letter = b
      for i = distance,1,-1
        turtle.back()
        
    elseif direction_letter = u
      for i = distance,1,-1
        turtle.up()

    elseif direction_letter = d
      for i = distance,1,-1
         turtle.down()

    else
      return "direction letter needs to be f,b,u or d"
end
        

