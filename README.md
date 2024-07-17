# Pirate Software - Game Jam 15

## [Game Design Document](https://docs.google.com/document/d/1WYirGlcXRuHeMPgCNsWms230mVQ8AWjAgVTe9EEO-y0/edit?usp=sharing)

## Project Setup
1. Download [Godot](https://godotengine.org/download/windows/).
2. Download [Visual Studio Code](https://code.visualstudio.com/download) (Simple to use as Git Editor).
3. Download [Git](https://git-scm.com/download/win) (When it asks what editor to use, select Visual Studio Code)
4. Open up Git Bash on your desktop and paste the following: `git clone https://github.com/m-casa/pirate-jam15.git`
5. You might be asked to log in. If so, allow git to log in through the desktop to make things easier.
6. Now open up Git Bash inside of the pirate-jam15 folder and paste the following to change to the dev branch: `git checkout dev`
7. Open Godot, select import, browse for the "PirateJam15" project inside the "pirate-jam15" folder you cloned from GitHub.

## Git Commands
- If git wants you to confirm your email: `git config --global user.email "you@example.com"`
- If you want to create a new branch for your own features: `git checkout -b your-branch-name`
- Add your new branch to GitHub (Only if you haven't already): `git push --set-upstream origin your-branch-name`
- To switch to an existing branch: `git checkout branch-name`
- Check occasionally if you made any changes to the project: `git status`
- Add all your changes so they're ready to be committed: `git add .`
- Commit your changes (It will open Visual Studio Code so you can give your changes a title): `git commit`
- Check if there are new changes from anyone else  `git pull origin your-branch-name`
- Push your changes to github (DON'T PUSH TO MAIN): `git push origin your-branch-name`

## Notes
- Make sure you pull new changes before pushing your own.
- If you want to merge your changes with the main branch, submit a pull request to someone through GitHub.
