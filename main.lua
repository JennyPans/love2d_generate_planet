local earth = nil
local shader = nil
local position = {x=0, y=0}
local time = 0
local scale_width = 1/4
local scale_height = 1/4
local angle = 0
local plan_to_spere = love.graphics.newShader([[
  const number pi = 3.14159265;
  const number pi2 = 2.0 * pi;

  extern number time;

  vec4 effect(vec4 color, Image texture, vec2 tc, vec2 pixel_coords)
  {
    vec2 p = 2.0 * (tc - 0.5);
    
    number r = sqrt(p.x*p.x + p.y*p.y);

    if (r > 1.0) discard;
    
    number d = r != 0.0 ? asin(r) / r : 0.0;
          
    vec2 p2 = d * p;
    
    number x3 = mod(p2.x / (pi2) + 0.5 + time, 1.0);
    number y3 = p2.y / (pi2) + 0.5;
    
    vec2 newCoord = vec2(x3, y3);
    
    vec4 sphereColor = color * Texel(texture, newCoord);
          
    return sphereColor;
  }
  ]])

local shader = love.graphics.newShader

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    earth = love.graphics.newImage("earth.png")
end

function love.update(dt)
  time = time + dt * -0.1
  plan_to_spere:send("time", time)
  angle = angle + 1
  if angle > 360 then
    angle = 0
  end
  -- scale_width = math.cos(math.rad(angle)) / 2
  -- scale_height = math.sin(math.rad(angle))
end

function love.draw()
    local screen_width = love.graphics.getWidth() / 2
    local screen_height = love.graphics.getHeight() / 2
    local center_x = screen_width - earth:getWidth() * scale_width / 2
    local center_y = screen_height - earth:getHeight() * scale_height / 2
    love.graphics.setShader(plan_to_spere)
    love.graphics.draw(earth, center_x, center_y, 0, scale_width, scale_height)
    love.graphics.setShader()

end