#######################################################
#
# demo-ruboto.rb (by Scott Moyer)
# 
# A simple look at how to generate and 
# use a RubotoActivity.
#
#######################################################

require 'ruboto/activity'
require 'ruboto/widget'
require 'ruboto/menu'
require 'ruboto/util/toast'
confirm_ruboto_version(10, false)

#
# ruboto_import_widgets imports the UI widgets needed
# by the activities in this script. ListView and Button 
# come in automatically because those classes get extended.
#

ruboto_import_widgets :LinearLayout, :EditText, :TextView, :ListView, :Button

#
# $activity is the Activity that launched the 
# script engine. The start_ruboto_activity
# method creates a new RubotoActivity to work with.
# After launch, the new activity can be accessed 
# through the $ruboto_demo (in this case) global.
# You man not need the global, because the block
# to start_ruboto_activity is executed in the 
# context of the new activity as it initializes. 
#
$activity.start_ruboto_activity "$ruboto_demo" do
	#
	# on_create uses methods created through
	# ruboto_import_widgets to build a UI. All
	# code is executed in the context of the 
	# activity.
	#
	def on_create(bundle)
		@eurosToKunas = 7.5381
		@kunasToEuros = 0.1327
		@baseText = "1 euro = #{@eurosToKunas} kune. 1 kuna = #{@kunasToEuros} euro\n"
		setContentView(
			linear_layout(:orientation => LinearLayout::VERTICAL) do
			@et = edit_text
			linear_layout do
				button :text => "Converti in euro",  :on_click_listener => proc{|v| my_clickToEuros(@et.getText)}
				button :text => "Converti in kune", :on_click_listener => proc{|v| my_clickToKunas(@et.getText)}
				button :text => "Valore di 1 euro", :on_click_listener => proc{|v| set_eurosToKunas(@et.getText)}
				button :text => "Valore di 1 kuna", :on_click_listener => proc{|v| set_kunasToEuros(@et.getText)}
			end
			linear_layout do
				button :text => "Reset",          :on_click_listener => proc{|v| reset}
				button :text => "List",          :on_click_listener => proc{|v| launch_list}
			end
			@tv = text_view :text => @baseText 
			end)
	end

	#
	# All "handle" methods register for the 
	# corresponding callback (in this case 
	# OnCreateOptionsMenu. Creates menus that
	# execute the corresponding block (still
	# in the context of the activity)
	#
	handle_create_options_menu do |menu|
		add_menu("Converti in euro") {my_click "Conversione in euro"}
		add_menu("Converti in kune") {my_click "Conversione in kune"}
		add_menu("Exit") {finish}
		true
	end

	#
	# Extra singleton methods for this activity
	# need to be declared with self. This one 
	# handles some of the button and menu clicks.
	# 
	def my_clickToEuros(text)
		toast text
		result = @et.getText.toString
		result = result.to_f*@kunasToEuros
		@et.setText text
		@tv.append "#{result} euro\n"
	end

	def my_clickToKunas(text)
		toast text
		result = @et.getText.toString
		result = result.to_f*@eurosToKunas
		@et.setText text
		@tv.append "#{result} kune\n"
	end

	def set_eurosToKunas(text)
		@eurosToKunas = text.toString.to_f
		@baseText = "1 euro = #{@eurosToKunas} kune. 1 kuna = #{@kunasToEuros} euro\n"
		@tv.setText @baseText
	end

	def set_kunasToEuros(text)
		@kunasToEuros = text.toString.to_f
		@baseText = "1 euro = #{@eurosToKunas} kune. 1 kuna = #{@kunasToEuros} euro\n"
		@tv.setText @baseText
	end

	def reset
		@eurosToKunas = 7.5381
		@kunasToEuros = 0.1327
		@baseText = "1 euro = #{@eurosToKunas} kune. 1 kuna = #{@kunasToEuros} euro\n"
		@tv.setText @baseText
	end
  #
  # Launches a separate activity for displaying
  # a ListView.
  #
  def launch_list
    self.start_ruboto_activity("$my_list") do
      setTitle "Pick Something"
      @list = ["Converti in euro", "Converti in kune"]
      def on_create(bundle)
        setContentView(list_view :list => @list, 
          :on_item_click_listener => proc{|av, v, pos, item_id| toast(@list[pos]); finish})
      end
    end
  end
end

