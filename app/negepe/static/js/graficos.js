
const GRAPH = {
  'graph01': (data) => {  
	console.log(data);
	var vlSpec = {
        $schema: 'https://vega.github.io/schema/vega-lite/v5.json',
        data: data,
		mark: 'bar',
        encoding: {
          y: {field: 'local', type: 'nominal', 
			  axis: {title: 'Locais'}
		  },
          x: {field: 'total',  type: 'quantitative', 
            aggregate: 'sum',
            axis: {
              title: 'Quantidade de servidores'
            }
		  },

		  	yOffset: {'field': 'sexo'},
		  	color: {'field': 'sexo'}

		},
		layer: [
			{
				mark: 'bar'
			},
		{
			mark: {type: 'text', style: 'label', align: 'left' },
			encoding: {
				y: {field: 'local'},
				text: {field: 'total', aggregate: 'sum'},
		  	xOffset: {'field': 'sexo'},
				color: {value: '#777'}
			}
		}
	
			]
      };
      // Embed the visualization in the container with id `vis`
      vegaEmbed('#vis', vlSpec);
}
}
const links = document.querySelectorAll(".links");
console.log(links);
links.forEach(
	(link) => {
		link.addEventListener('click', (e) => {
			showGraph(e.target.dataset.grafico);
		})
	}
)

function showGraph(graph) {
    console.log(graph);
	fetch('/core/servidores2')
		.then(response => {return response.json()})
		.then(data => {
			GRAPH[graph]({values: data});
		});
}


