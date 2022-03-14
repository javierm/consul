author = Administrator.first.user

poll_description_en = <<~TEXT
  <p>This participatory process to determine the theme of the "Prospective Research" programme for the
  Innoviris call for projects in 2023 is being carried out in cooperation with and under the leadership of
  the European PRO-Ethics project. The aim of the project is to develop an ethical framework for
  participation processes in innovation policy. To this end, several European funding bodies are
  simultaneously conducting participation pilot projects and evaluating them in a scientific follow-up.
  To this end, citizen participation activities are documented by project staff.</p>

  <p>Innoviris makes every effort to ensure the confidentiality and security of the individual data
  processed. The retention time will be that necessary to achieve the purposes of the processing concerned.
  If you have any questions or wish to apply your rights under Articles 15 to 22 of the GDPR, please
  contact dpo@innoviris.brussels.</p>
TEXT

poll_description_fr = <<~TEXT
  <p>Ce processus participatif pour déterminer le thème du programme "Prospective Research" pour l’appel à
  projet Innoviris en 2023 est réalisé en coopération avec et sous la direction du projet européen
  PRO-Ethics. L’objectif du projet est de développer un cadre éthique pour les processus de participation
  dans la politique d’innovation. À cette fin, plusieurs organismes de financement européens mènent
  simultanément des projets pilotes de participation et les évaluent dans le cadre d’un suivi scientifique.
  À cette fin, les activités de participation des citoyens sont documentées par le personnel du projet.</p>

  <p>Innoviris met tout en oeuvre pour garantir la confidentialité et la sécurité des données individuelles
  traitées. Le temps de rétention sera celui nécessaire pour accomplir les objectifs du traitement concerné.
  Si vous avez des questions ou que vous désirez appliquer vos droits en vertu des articles15 à 22 du RGPD,
   veuillez contacter dpo@innoviris.brussels.</p>
TEXT

poll_summary_en = <<~TEXT
  <p>For a future call, Innoviris would like to consult you, the citizens, on the central Brussels issues
  that you identify and would like to see worked on by research organisations.</p>

  <p>The research projects will present their policy recommendations to the members of the Brussels
  Parliament after their completion, with the aim of achieving well thought-out solutions that address
  the challenge and benefit the well-being of the Brussels population. For Innoviris, it is therefore
  important to have a good understanding of the most widespread challenges among the Brussels population.
  These will be further developed in consultation with a panel of citizens.</p>
  TEXT

poll_summary_fr = <<~TEXT
  <p>Pour un prochain appel, Innoviris souhaite consulter vous, citoyens, sur les enjeux bruxellois centraux
  que vous identifiez et que vous souhaiteriez voir travailler par des organismes de recherche.</p>

  <p>Les projets de recherche présenteront leurs recommandations politiques aux membres du Parlement
  bruxellois après leur achèvement, dans le but d'obtenir des solutions bien pensées qui répondent au défi et
  bénéficient au bien-être de la population bruxelloise. Pour Innoviris, il est donc important de bien
  comprendre quels sont les défis les plus répandus parmi la population bruxelloise. Elles seront développées
  ultérieurement en consultation avec un panel de citoyens.</p>
  TEXT

poll_texts = {
  name_en: "Innoviris open poll",
  name_fr: "Innoviris sondage ouvert",
  description_en: poll_description_en,
  description_fr: poll_description_fr,
  summary_en: poll_summary_en,
  summary_fr: poll_summary_fr
}
poll = Poll.find_or_create_by!(name: "Open poll",
                               description: "Open poll",
                               starts_at: Time.current - 1.day,
                               ends_at: Time.current + 1.month,
                               author: author)

poll.update!(poll_texts)

question_1_title_en = <<~TEXT
  From your perspective, based on your experiences, what are the major challenges facing the region in the
  next 20 years? Choose the most important challenge for you
TEXT

question_1_title_fr = <<~TEXT
  De votre point de vue, de par vos expériences, à quels défis majeurs la région va devoir faire face dans
  les 20 prochaines années? Choisissez le défi le plus important pour vous
TEXT

# Question 1
question_1_texts = {
  title_en: question_1_title_en,
  title_fr: question_1_title_fr,
  description_en: "Choose the most important challenge for you",
  description_fr: "Choisissez le défi le plus important pour vous"
}
question_1 = Poll::Question.find_or_create_by!(poll: poll, author: author, title: "Sample",
                                               mandatory_answer: true)
question_1.update!(question_1_texts)

question_1_answer_1_texts = {
  title_en: "Challenge 1 - buildings independent of external energy suppliers",
  title_fr: "Défi 1 - des bâtiments indépendants des fournisseurs d'énergie externes",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_1, given_order: 1, title: "Sample")
                      .update!(question_1_answer_1_texts)

question_1_answer_2_texts = {
  title_en: "Challenge 2 - a less curative and more preventive health system",
  title_fr: "Défi 2 - un système de santé moins curatif et plus préventif",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_1, given_order: 2, title: "Sample")
                      .update!(question_1_answer_2_texts)

question_1_answer_3_texts = {
  title_en: "Challenge 3 ...",
  title_fr: "Défi 3 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_1, given_order: 3, title: "Sample")
                      .update!(question_1_answer_3_texts)

question_1_answer_4_texts = {
  title_en: "Challenge 4 ...",
  title_fr: "Défi 4 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_1, given_order: 4, title: "Sample")
                      .update!(question_1_answer_4_texts)

question_1_answer_5_texts = {
  title_en: "Challenge 5 ...",
  title_fr: "Défi 5 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_1, given_order: 5, title: "Sample")
                      .update!(question_1_answer_5_texts)

question_1_answer_6_texts = {
  title_en: "Challenge 6 ...",
  title_fr: "Défi 6 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_1, given_order: 6, title: "Sample")
                      .update!(question_1_answer_6_texts)

question_1_answer_7_texts = {
  title_en: "Challenge 7 ...",
  title_fr: "Défi 7 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_1, given_order: 7, title: "Sample")
                      .update!(question_1_answer_7_texts)

# Question 2
question_2_title_en = <<~TEXT
  From your perspective, based on your experiences, what are the major challenges facing the region in the
  next 20 years? Choose the second most important challenge for you
TEXT

question_2_title_fr = <<~TEXT
  De votre point de vue, de par vos expériences, à quels défis majeurs la région va devoir faire face dans
  les 20 prochaines années? Choisissez le deuxième défi le plus important pour vous
TEXT

question_2_texts = {
  title_en: question_2_title_en,
  title_fr: question_2_title_fr,
  description_en: "Choose the second most important challenge for you",
  description_fr: "Choisissez le deuxième défi le plus important pour vous"
}
question_2 = Poll::Question.find_or_create_by!(poll: poll, author: author, title: "Sample",
                                               mandatory_answer: true)
question_2.update!(question_2_texts)

question_2_answer_1_texts = {
  title_en: "Challenge 1 - buildings independent of external energy suppliers",
  title_fr: "Défi 1 - des bâtiments indépendants des fournisseurs d'énergie externes",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_2, given_order: 1, title: "Sample")
                      .update!(question_2_answer_1_texts)

question_2_answer_2_texts = {
  title_en: "Challenge 2 - a less curative and more preventive health system",
  title_fr: "Défi 2 - un système de santé moins curatif et plus préventif",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_2, given_order: 2, title: "Sample")
                      .update!(question_2_answer_2_texts)

question_2_answer_3_texts = {
  title_en: "Challenge 3 ...",
  title_fr: "Défi 3 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_2, given_order: 3, title: "Sample")
                      .update!(question_2_answer_3_texts)

question_2_answer_4_texts = {
  title_en: "Challenge 4 ...",
  title_fr: "Défi 4 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_2, given_order: 4, title: "Sample")
                      .update!(question_2_answer_4_texts)

question_2_answer_5_texts = {
  title_en: "Challenge 5 ...",
  title_fr: "Défi 5 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_2, given_order: 5, title: "Sample")
                      .update!(question_2_answer_5_texts)

question_2_answer_6_texts = {
  title_en: "Challenge 6 ...",
  title_fr: "Défi 6 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_2, given_order: 6, title: "Sample")
                      .update!(question_2_answer_6_texts)

question_2_answer_7_texts = {
  title_en: "Challenge 7 ...",
  title_fr: "Défi 7 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_2, given_order: 7, title: "Sample")
                      .update!(question_2_answer_7_texts)

# Question 3
question_3_title_en = <<~TEXT
  From your perspective, based on your experiences, what are the major challenges facing the region in the
  next 20 years? Choose the third most important challenge for you
TEXT

question_3_title_fr = <<~TEXT
  De votre point de vue, de par vos expériences, à quels défis majeurs la région va devoir faire face dans
  les 20 prochaines années? Choisissez le troisième défi le plus important pour vous
TEXT

question_3_texts = {
  title_en: question_3_title_en,
  title_fr: question_3_title_fr,
  description_en: "Choose the third most important challenge for you",
  description_fr: "Choisissez le troisième défi le plus important pour vous"
}
question_3 = Poll::Question.find_or_create_by!(poll: poll, author: author, title: "Sample",
                                               mandatory_answer: true)
question_3.update!(question_3_texts)

question_3_answer_1_texts = {
  title_en: "Challenge 1 - buildings independent of external energy suppliers",
  title_fr: "Défi 1 - des bâtiments indépendants des fournisseurs d'énergie externes",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_3, given_order: 1, title: "Sample")
                      .update!(question_3_answer_1_texts)

question_3_answer_2_texts = {
  title_en: "Challenge 2 - a less curative and more preventive health system",
  title_fr: "Défi 2 - un système de santé moins curatif et plus préventif",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_3, given_order: 2, title: "Sample")
                      .update!(question_3_answer_2_texts)

question_3_answer_3_texts = {
  title_en: "Challenge 3 ...",
  title_fr: "Défi 3 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_3, given_order: 3, title: "Sample")
                      .update!(question_3_answer_3_texts)

question_3_answer_4_texts = {
  title_en: "Challenge 4 ...",
  title_fr: "Défi 4 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_3, given_order: 4, title: "Sample")
                      .update!(question_3_answer_4_texts)

question_3_answer_5_texts = {
  title_en: "Challenge 5 ...",
  title_fr: "Défi 5 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_3, given_order: 5, title: "Sample")
                      .update!(question_3_answer_5_texts)

question_3_answer_6_texts = {
  title_en: "Challenge 6 ...",
  title_fr: "Défi 6 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_3, given_order: 6, title: "Sample")
                      .update!(question_3_answer_6_texts)

question_3_answer_7_texts = {
  title_en: "Challenge 7 ...",
  title_fr: "Défi 7 ...",
  description_en: "<p>Context bla bla bla</p>",
  description_fr: "<p>Contexte bla bla bla</p>"
}
Poll::Question::Answer.find_or_create_by!(question: question_3, given_order: 7, title: "Sample")
                      .update!(question_3_answer_7_texts)
# Question 4
question_4_texts = {
 title_en: "What challenge has not been mentioned above but in your opinion deserves attention?",
 title_fr: "Quel défi n'a pas été mentionné ci-dessus mais mérite, à votre avis, qu'on s'y attarde?"
}
Poll::Question.find_or_create_by!(poll: poll, author: author, title: "Sample")
              .update!(question_4_texts)

# Question 5
question_5_texts = {
  title_en: "What is the postal code of your town?",
  title_fr: "Quel est le code postal de votre commune?"
 }
Poll::Question.find_or_create_by!(poll: poll, author: author, title: "Sample")
              .update!(question_5_texts)

# Question 6
question_6_texts = {
  title_en: "How old are you?",
  title_fr: "Quel âge avez-vous?"
 }
question_6 = Poll::Question.find_or_create_by!(poll: poll, author: author, title: "Sample")
question_6.update!(question_6_texts)

# Question 5
question_5_texts = {
  title_en: "What is your gender?",
  title_fr: "Quel est votre sexe?"
 }
question_5 = Poll::Question.find_or_create_by!(poll: poll, author: author, title: "Sample")
question_5.update!(question_5_texts)

question_5_answer_1_texts = {
  title_en: "Female",
  title_fr: "Femme"
}
Poll::Question::Answer.find_or_create_by!(question: question_5,
                                          given_order: 1,
                                          title: "Sample")
                      .update!(question_5_answer_1_texts)
question_5_answer_2_texts = {
  title_en: "Male",
  title_fr: "Homme"
}
Poll::Question::Answer.find_or_create_by!(question: question_5,
                                          given_order: 2,
                                          title: "Sample")
                      .update!(question_5_answer_2_texts)
question_5_answer_3_texts = {
  title_en: "Non-binary",
  title_fr: "Non-binaire"
}
Poll::Question::Answer.find_or_create_by!(question: question_5,
                                          given_order: 3,
                                          title: "Sample")
                      .update!(question_5_answer_3_texts)

# Question 6
question_6_texts = {
  title_en: "What is your level of education?",
  title_fr: "Quel est votre plus haut niveau d'éducation?"
 }
question_6 = Poll::Question.find_or_create_by!(poll: poll, author: author, title: "Sample")
question_6.update!(question_6_texts)
question_6_answer_1_texts = {
  title_en: "Primary education",
  title_fr: "L'enseignement primaire"
}
Poll::Question::Answer.find_or_create_by!(question: question_6,
                                          given_order: 1,
                                          title: "Sample")
                      .update!(question_6_answer_1_texts)
question_6_answer_2_texts = {
  title_en: "Lower secondary education",
  title_fr: "Enseignement secondaire inférieur"
}
Poll::Question::Answer.find_or_create_by!(question: question_6,
                                          given_order: 2,
                                          title: "Sample")
                      .update!(question_6_answer_2_texts)
question_6_answer_3_texts = {
  title_en: "Part-time secondary vocational education",
  title_fr: "Enseignement secondaire professionnel à temps partiel"
}
Poll::Question::Answer.find_or_create_by!(question: question_6,
                                          given_order: 3,
                                          title: "Sample")
                      .update!(question_6_answer_3_texts)
question_6_answer_4_texts = {
  title_en: "Upper secondary education",
  title_fr: "Enseignement secondaire supérieur"
}
Poll::Question::Answer.find_or_create_by!(question: question_6,
                                          given_order: 4,
                                          title: "Sample")
                      .update!(question_6_answer_4_texts)
question_6_answer_5_texts = {
  title_en: "Short term higher education",
  title_fr: "L'enseignement supérieur type court"
}
Poll::Question::Answer.find_or_create_by!(question: question_6,
                                          given_order: 5,
                                          title: "Sample")
                      .update!(question_6_answer_5_texts)
question_6_answer_6_texts = {
  title_en: "Long term higher education",
  title_fr: "L'enseignement supérieur type long"
}
Poll::Question::Answer.find_or_create_by!(question: question_6,
                                          given_order: 6,
                                          title: "Sample")
                       .update!(question_6_answer_6_texts)

# Question 7
question_7_texts = {
  title_en: "I would like to be informed about the results of this process. Please, enter your email.",
  title_fr: "Je souhaite être informé des résultats de ce processus. S'il vous plaît, entrez votre email."
 }
Poll::Question.find_or_create_by!(poll: poll, author: author, title: "Sample")
              .update!(question_7_texts)
