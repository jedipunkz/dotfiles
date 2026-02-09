return {
  -- Grug-far for find and replace
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    config = function()
      require("replace")
    end,
  },
}
