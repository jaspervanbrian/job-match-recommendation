module ApplicationHelper
  def navbar_active_tab_helper(path)
    if current_page?(path)
      "inline-flex items-center justify-center p-4 text-blue-600 border-b-2 border-blue-600 rounded-t-lg active dark:text-blue-500 dark:border-blue-500 group"
    else
      "inline-flex items-center justify-center p-4 border-b-2 border-transparent rounded-t-lg hover:text-gray-600 hover:border-gray-300 dark:hover:text-gray-300 group"
    end
  end

  def navbar_active_tab_icon_helper(path)
    if current_page?(path)
      "text-blue-600 dark:text-blue-500"
    else
      "text-gray-400 group-hover:text-gray-500 dark:text-gray-500 dark:group-hover:text-gray-300"
    end
  end
end
