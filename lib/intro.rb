# frozen_string_literal: false

# Intro class.
class Intro
  def initialize
    @title = "\e[91m
    An Odin Production, Ruby Final Project
     ██████╗██╗  ██╗███████╗███████╗███████╗
    ██╔════╝██║  ██║██╔════╝██╔════╝██╔════╝
    ██║     ███████║█████╗  ███████╗███████╗
    ██║     ██╔══██║██╔══╝  ╚════██║╚════██║
    ╚██████╗██║  ██║███████╗███████║███████║
     ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
     \e[0m"
  end

  def to_s
    @title
  end
end
