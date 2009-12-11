# do some OpenGL rendering
glTranslatef -5, 0, -5            # move forward and left 5 units
3.times do |color|
  # draw a square and then move 5 units to the right; do this 3 times
  glColor4fv(@colors[color])       # set the current color
  glBegin GL_QUADS
    glVertex3f -1, -1, 0          # top left
    glVertex3f -1,  1, 0          # bottom left
    glVertex3f  1,  1, 0          # bottom right
    glVertex3f  1, -1, 0          # top right
  glEnd
  glTranslatef(5,0,0)
end