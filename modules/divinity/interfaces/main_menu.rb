interface :main_menu do
  panel :center do
    layout :grid, 3, 12
    button :single_player, :constraints => [1, 4]
    #button :multi_player,  :constraints => [1, 5]

    panel [1,5] do
      layout :grid, 2, 1
      button :left, :constraints => [0,0]
      button :right, :constraints => [1,0]
    end
    button :options,       :constraints => [1, 6]
    button :quit,          :constraints => [1, 7]
  end
end
