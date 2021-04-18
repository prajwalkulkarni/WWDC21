//
//  QuizLogicHandler.swift
//  Book_Sources
//
//  Created by Prajwal Kulkarni on 16/04/21.
//


struct QuizLogicHandler{
    
    //Current question number
    var questionNumber: Int = 0
    
    //Array of stake money for each of the 7 questions.
    let stake = ["$500","$1000","$10000","$50000","$100000","$500000","$1000000"]
    
    //MARK: - Question array
    //Array of questions
    var question = [
        Question(q: "When you're visiting a supermarket, which bag should you consider carrying with you?", optns: ["Plastic bag","Paper bag","Reusable bag","None of the above"], a: 2,i: "Reusable bags are easier to use for both loading and unloading items. They're less likely to have their handle tear off or develop a hole if any sharp products press into them. Additionally, they also help in conserving resources and decrease pollution, as there is no need to decompose which probably ends up in a landfill."),
        Question(q: "Assume you're planning to buy a new phone, which of these would benefit both you and the environment?", optns: ["iPhone 12 variant","iPhone 7","Samsung S20","Xiaomi Redmi 5"], a: 0,i: "iPhone 12 uses more recyclable materials than past models, including 100% recycled rare earth metals in its magnets. The device is shipped with the removal of the lightning cable earphones and wall adapter, as vast amounts of both these items exist in the world, and removing them from the box will reduce their carbon footprint. Kudos to Apple for taking an environmentally friendly decision and also giving the world a top-notch smartphone."),
        
        Question(q: "Which of the Industries produce the second highest greenhouse gas?", optns: ["Agriculture","Transportation","Waste management","Electricity production"], a: 3,i: "Electricity production generates the second largest share of greenhouse gas emissions. Approx. 63% of our electricity comes from burning fossil fuels, mostly coal and natural gas. It is thus encouraged to exploit renewable sources of energy such as wind and sun to generate electricity. Also, as a good rule of thumb, it is always recommended to turn off appliances(A/C, TV, Laundry machine, lights) when not in use. This would help us in saving electricity."),
        
        Question(q: "You decide to reduce greenhouse gas emissions by becoming vegetarian for a year. Your friend doesn't want to change his/her diet, but decides to cut down by purchasing only non-packaged food. How many years would it take your friend to save the same amount of greenhouse as you ?", optns: ["5 years","11 years","7 years","15 years"], a: 1,i: "You'd have to avoid food packaging for approximately 11 years to have the same impact as one year without meat, according to a 2013 study. Producing plant-based foods also require far less land(23%) as compared to Livestock(Meat and dairy, 77%), which results in lesser deforestation, meaning contributing lesser carbon footprint :)."),
        
        Question(q: "Which of these, do you think produce the majority of world's oxygen?", optns: ["Rainforests (Amazon rainforest)","Oceans(Phytoplankton)","Grass","Flowers"], a: 1,i: "Scientists estimate that 50-80% of oxygen comes from the ocean. The majority of the production comes from the oceanic plankton - drifting plants, algae, and some bacteria that can photosynthesize - that is they use sunlight and carbon dioxide to make food, the byproduct is oxygen. Let's all be thankful for the nature around us for letting us exist."),
        
        Question(q: "Which of these countries emits the most carbon dioxide?", optns: ["UK","Russia","China","USA"], a: 2, i: "According to the International Energy Agency, China is currently the top emitter of carbon dioxide, accounting for 28% of global carbon emissions. The United States ranks as the second top emitter at 15%, followed by India at 7%."),
        
        Question(q:"What was agreed to, in the 'Paris agreement', held in Paris 2015?",optns: ["To protect biodiversity and end deforestation.","To pursue a goal of 100% clean, renewable energy","To limit sea level rise  to 3 feet above current levels","To keep global temperature rise below 2C"],a: 3,i: "The Paris agreement is an international treaty on climate change. It aims to keep the overall increase in global temperature below 2 degrees Celsius, with the hope of limiting it to 1.5 degrees Celsius. Scientists believe that these are the largest increase in global temperature that we could experience without causing catastrophic change to the Earth's climate."),
        
        
        
        
    ]
    
    //MARK: - Mutating variable values
    //Mutating function to update variable values in a struct.
    mutating func resetQuestions(){
        question.shuffle()
        questionNumber = 0
    }
    
    //Mutating function to update variable values in a struct.
       mutating func nextQuestion(){
           if questionNumber < question.count{
               questionNumber += 1
           }
           
       }
    
    //MARK: - Getters
    //Check if user answer is the actual answer. Return type: Boolean
    func correctAnswer(_ response: Int) -> Bool{
        
        if response == question[questionNumber].answer {
            return true
        }
        else{
            return false
        }
    }
    
   
    
    //Check if all the questions have been answered.
    func isOver() -> Bool {
        if questionNumber >= question.count {
            return true
        }
        else{
            return false
        }
    }
    
    //Returns the current question. Return type: String
    func getQuestion() -> String {
        
        return question[questionNumber].question
    }
    
    //Returns the index of the correct option. Return type: Integer
    func getAnswer() -> Int {
        return question[questionNumber].answer
    }
    
    //Returns current question's stake money. Return type: String
    func getStake() -> String{
        return stake[questionNumber]
    }
    
    //Returns information about the answer. Return type: String
    func getInfo() -> String{
        return question[questionNumber].info
    }
    
    //Returns content of the option. Accepts an integer to identify the option and outputs a string corresponding to the passed integer. Return type: String
    func getOption(optionNumber option: Int) -> String {
        return question[questionNumber].options[option]
    }
    
}

