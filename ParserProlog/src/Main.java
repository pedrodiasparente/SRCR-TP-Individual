import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        try {
            FileReader reader = new FileReader("prolog/lista_adjacencias_paragens.csv");

            try (BufferedReader br = new BufferedReader(reader)) {
                ArrayList<String> lines = new ArrayList<>();
                String parts1[];
                String parts2[];
                String line;
                FileWriter writerFile = new FileWriter("prolog/base_de_conhecimento.pl");

                while ((line = br.readLine()) != null) {
                    lines.add(line);
                }
                reader.close();
                writerFile.write(":- dynamic adjacente/2.\n");
                writerFile.write(":- dynamic paragem/11.\n");
                for(int i = 1; i < lines.size() - 1; i++){
                    parts1 = lines.get(i).split(";");
                    parts2 = lines.get(i+1).split(";");
                    if (parts1[7].equals(parts2[7])){
                        writerFile.write("adjacente(");
                        writerFile.write("paragem(" + parts1[0] + "," + parts1[1] + "," + parts1[2] + ",'" + parts1[3] + "','" + parts1[4] + "','" + parts1[5] + "','" + parts1[6] + "'," + parts1[7] + "," + parts1[8] + ",'" + parts1[9] + "','" + parts1[10] + "'),");
                        writerFile.write("paragem(" + parts2[0] + "," + parts2[1] + "," + parts2[2] + ",'" + parts2[3] + "','" + parts2[4] + "','" + parts2[5] + "','" + parts2[6] + "'," + parts2[7] + "," + parts2[8] + ",'" + parts2[9] + "','" + parts2[10] + "')");
                        writerFile.write(").\n");
                        writerFile.write("adjacente(");
                        writerFile.write("paragem(" + parts2[0] + "," + parts2[1] + "," + parts2[2] + ",'" + parts2[3] + "','" + parts2[4] + "','" + parts2[5] + "','" + parts2[6] + "'," + parts2[7] + "," + parts2[8] + ",'" + parts2[9] + "','" + parts2[10] + "'),");
                        writerFile.write("paragem(" + parts1[0] + "," + parts1[1] + "," + parts1[2] + ",'" + parts1[3] + "','" + parts1[4] + "','" + parts1[5] + "','" + parts1[6] + "'," + parts1[7] + "," + parts1[8] + ",'" + parts1[9] + "','" + parts1[10] + "')");
                        writerFile.write(").\n");
                    }
                }

                for(int i = 1; i < lines.size() - 1; i++){
                    parts1 = lines.get(i).split(";");
                    writerFile.write("paragem(" + parts1[0] + "," + parts1[1] + "," + parts1[2] + ",'" + parts1[3] + "','" + parts1[4] + "','" + parts1[5] + "','" + parts1[6] + "'," + parts1[7] + "," + parts1[8] + ",'" + parts1[9] + "','" + parts1[10] + "').\n");
                }
                parts2 = lines.get(lines.size()-1).split(";");
                writerFile.write("paragem(" + parts2[0] + "," + parts2[1] + "," + parts2[2] + ",'" + parts2[3] + "','" + parts2[4] + "','" + parts2[5] + "','" + parts2[6] + "'," + parts2[7] + "," + parts2[8] + ",'" + parts2[9] + "','" + parts2[10] + "').\n");
                writerFile.close();
            }
        } catch (IOException e) {
            System.out.println("Erro a ler/escrever ficheiro");
        }
    }
}
