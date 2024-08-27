local M = {}

local Category = {
	APPLICATION = "application",
	GRAPHQL = "graphql",
	TEST = "test",
}

local CategoryIcons = {
	[Category.APPLICATION] = "󰘙",
	[Category.GRAPHQL] = "󰡷",
	[Category.TEST] = "󰙨",
}

local function create_finder(name, icon, color, module, category)
	return { name = name, icon = icon, color = color, module = module, category = category }
end

local finders = {
	create_finder("Models", "󰆧", "#4CAF50", "model", Category.APPLICATION),
	create_finder("Controllers", "󰅱", "#2196F3", "controller", Category.APPLICATION),
	create_finder("Migrations", "󰁯", "#FFC107", "migration", Category.APPLICATION),
	create_finder("Views", "󰕦", "#9C27B0", "view", Category.APPLICATION),
	create_finder("Services", "󰑭", "#FF5722", "service", Category.APPLICATION),
	create_finder("Types", "󰅠", "#00BCD4", "graphql_type", Category.GRAPHQL),
	create_finder("Mutations", "󰁨", "#3F51B5", "graphql_mutation", Category.GRAPHQL),
	create_finder("Resolvers", "󰘦", "#009688", "graphql_resolver", Category.GRAPHQL),
	create_finder("Model tests", "󰙨", "#8BC34A", "model_test", Category.TEST),
	create_finder("Controller tests", "󰤑", "#03A9F4", "controller_test", Category.TEST),
	create_finder("System tests", "󰡑", "#FF9800", "system_test", Category.TEST),
	create_finder("Service tests", "󰤖", "#FF5252", "service_test", Category.TEST),
}

local function create_divider(text)
	return { is_divider = true, text = text }
end

local function format_item(item)
	if item.is_divider then
		return string.format("%s %s %s", string.rep("─", 10), item.text, string.rep("─", 10))
	else
		return string.format("%s %s", item.icon, item.name)
	end
end

function M.select_finders()
	local display_finders = {}
	local current_category = nil

	for _, finder in ipairs(finders) do
		if finder.category ~= current_category then
			if #display_finders > 0 then
				table.insert(display_finders, create_divider(""))
			end
			local icon = CategoryIcons[finder.category] or ""
			local category_name = finder.category:upper()
			table.insert(display_finders, create_divider(icon .. " " .. category_name .. " " .. icon))
			current_category = finder.category
		end
		table.insert(display_finders, finder)
	end

	vim.ui.select(display_finders, {
		prompt = "What are you looking for?",
		format_item = format_item,
	}, function(selection)
		if selection and selection.module then
			require("ror.finders." .. selection.module).find()
		end
	end)
end

return M
