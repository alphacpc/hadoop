#Demarrer hadoop
> ./start-hadoop.sh
    (Démarrage de Hadoop & Yarn)

#Create a directory
> hadoop fs -mkdir -p input (-p permet de créer tous le chemin jusqu'au répertoire)

#Copier un fichier dans HDFS
> hadoop fs -put monfichier.txt input
    (hadoop va découper le fichier en un ensemble de bloc et leur répartition sur l'ensemble des Data Node du cluster)

#Afficher le contenu du répertoire input
> hadoop fs -ls input  

#Afficher les derniers ligne d'un fichier
> hadoop fs -tail input/monfichier.txt

# Télécharger un fichier dans HDFS
> hadoop fs -get <path[filename]>

#Il existe une interface pour visualiser ce qui se passe dans hadoop
#On peut écouter sur le port 50070 : pour les information du namenode
# Le port 8088: Pour afficher les information de Yarn et le comportement des différents jobs



#MapReduce Avec Java (Wordcount)
#Pour se faire, il faut créer un projet java (de préférence utilisé l'éditeur Intellij)
#Composant du projet : src, pom.xml)
    # src: contient deux dossiers (main et test), ce qui nous intéresse et le dossier main
    # main: également contient deux dossier (java et resources)
    # java: le dossier java va contenir tous nos codes java
    # resources: cet dossier contient les ressources nécessaire pour notre projet c'est comme le node_modules en Javascript
    # pom.xml: le fichier de configuration, peut également contenir les dépendances néccessaire pour notre projet
    # dans pom.xml:  On peut ajouter les dépendances comme (hadoop-common, hadoop-mapreduce-client-core, hadoop-hdfs, hadoop-mapreduce-client-common)
#Créer un package sn.galsen.tp1
#Créer une classe TokenizerMapper.java
    #Le code devra etre
    package sn.galsen.tp1

    import org.apache.hadoop.io.IntWritable;
    import org.apache.hadoop.io.Text;
    import org.apache.hadoop.mapreduce.Mapper;

    import java.io.IOException;
    import java.util.StringTokenizer;

    public class TokenizerMapper extends Mapper<Object, Text, Text, IntWritable>{
        private finale static IntWritable one = new IntWritable(1);
        private Text word = new Text();

        public void map(Object key, Text value, Mapper.Context context){
            throws IOException, InterruptedException{
                StringTokenizer itr = new StringTokenizer(value.toString());

                while (itr.hasMoreTokens()){
                    word.set(itr.nextToken());
                    context.write(word, one);
                }
            }
        }
    }


#Créer une classe SumReducer.java
    package sn.galsen.tp1

    mport org.apache.hadoop.io.IntWritable;
    import org.apache.hadoop.io.Text;
    import org.apache.hadoop.mapreduce.Reducer;

    import java.io.IOException;

    public class SumReducer extends Mapper<Text, IntWritable, Text, IntWritable>{
        private IntWritable result = new IntWritable(1);

        public void reducer(Text key, Iterable<IntWritable> values, Context context){
            throws IOException, InterruptedException{

                int sum = 0;

                for(IntWritable val: values){
                    System.out.println("value: " + val.get());
                    sum += val.get();
                }
                System.out.println(" ===> sum = " + sum);
                result.set(sum);

                Context.write(key, result);
 
            }
        }
    }


#Créer la classe Wordcount

    package sn.galsen.tp1;

    import org.apache.hadoop.conf.Configuration;
    import org.apache.hadoop.fs.Path;
    import org.apache.hadoop.io.IntWritable;
    import org.apache.hadoop.io.Text;
    import org.apache.hadoop.mapreduce.Job;
    import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
    import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;


    public class WordCount{
        public static void main(String[] args) throws Exception{
            Configuration conf = new Configuration();
            Job job = Job.getInstance(conf, "word count");
            job.setJarByClass(WordCount.class);
            job.setMapperClass(TokenizerMapper.class);
            job.setCombinerClass(SumReduce.class);
            job.setReduceClass(SumReduce.class);
            job.OuputKeyClass(Text.class);
            job.OutputValueClass(IntWritable.class);
            FileInputFormat.addInputPath(job, new Path(args[0]));
            FileOutputFormat.addOutputPath(job, new Path(args[1]));
            System.exit(job.waitForCompletion(true) ? 0 : 1);
        }
    }

#Pour text MapReducer en local
#Tout d'abord dans resources on va créer un dossier nommé input qui va contenir un fichier file.txt
#Dans file.txt
    hello world!
    hello mapreduce!
    hello galsen!
    hello dakarscript!

#Essayer dans notre cluster
#Il faut d'abord créer un fichier jar executable
#Donc un fichier Wordcount-1.jar est créé et il faut le copié dans notre container master
# docker cp target/Wordcount-1.jar hadoop-master:/root/Wordcount-1.jar
#dans le container faire un ls

#Executer le fichier dans le container
    #hadoop jar Wordcount-1.jar sn.galsen.tp1 input output
    #hadoop fs -ls output
    #hadoop fs -get output/part-r-0000












###########################
###########################
#Introduction dans HBASE
###########################
###########################

#Utilise l'architecture maitre esclave
#HMaster, Region Server, Zookeeper
#HBase est orienté colonne => les fichiers sont stockés dans HDFS
#Il faut savoir que les données sont semi-structurées

#Créer une table et des colonnes
> hbase shell
> create 'sales_ledger', 'customer', 'sales'
> list (Pour lister les tables)

#Inserer des données dans Hbase
> put 'sales_ledger', '1', 'customer:name', 'Luka Modric'
> put 'sales_ledger', '1', 'customer:city', 'Madrid'
> put 'sales_ledger', '1', 'sales:product', 'Tshirt'
> put 'sales_ledger', '1', 'sales:amount', '$400'

#Visualiser les données saisies dans Hbase
> scan 'sales_ledger'
(à eviter pour des fichiers trop volumineux)

#Recupere un élément particulier
> get 'sales_ledger', '1', {COLUMN => 'sales:product'}


#Charger un fichier volumineux dans Hbase
> create 'products', 'cf'

> hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator=',' -Dimporttsv.columns=HBASE_ROW_KEY,cf:date,cf:time,cf:town,cf:product,cf:price,cf:payment products input

> hbase shell

> list

> get 'products', '1', {COLUMN => 'cf:product'}