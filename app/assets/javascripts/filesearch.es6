const { Component, h, render } = window.preact;

class LinkSearch extends Component {
  constructor(props) {
    super(props);

    this.haystackLimit = props.haystackLimit || 20;
    this.haystackAsNeedles =
      props.haystack.slice(0, this.haystackLimit).map(function (item) {
        return {
          item: item,
          matches: [
            { indices: [] }
          ],
          score: 0.001
        };
      });

    this.state = {
      query: "",
      needles: this.haystackAsNeedles
    };

    this.handleQueryUpdate = this.handleQueryUpdate.bind(this);
  }

  handleQueryUpdate(event) {
    var query = event.target.value;
    var results;

    if (query === "") {
      results = this.haystackAsNeedles;
    } else {
      results = this.props.fuse.search(query);
    }

    this.setState({
      query: query,
      needles: results
    });
  };

  render(props, state) {
    return (
      h("div", null,
        h(LinkSearchInput, { value: state.query, handleInput: this.handleQueryUpdate }),
        h(LinkSearchResultList, { results: state.needles, limit: this.haystackLimit })
      )
    );
  }
}

class LinkSearchInput extends Component {
  render(props, state) {
    return (
      h("input", { onInput: props.handleInput, value: props.value })
    );
  }
}

class LinkSearchResultList extends Component {
  render(props, state) {
    return (
      h("ul", null,
        props.results.slice(0, props.limit).map(function (result) {
          return h(LinkSearchResult, { result: result });
        })
      )
    );
  }
}

class LinkSearchResult extends Component {
  parseIndexes(nameLength, matchIndexes) {
    var parsed = [];
    var index = 0;
    var prevChar = 0;
    var current;

    while (matchIndexes[index]) {
      current = matchIndexes[index];

      if (prevChar !== current[0]) {
        parsed.push(["normal", prevChar, current[0]]);
      }

      parsed.push(["bold", current[0], current[1] + 1]);

      prevChar = current[1] + 1;

      index = index + 1;
    }

    if (prevChar !== nameLength) {
      parsed.push(["normal", prevChar, nameLength]);
    }

    return parsed;
  }

  renderName(name, matchIndexes) {
    var parsedIndexes = this.parseIndexes(name.length, matchIndexes);

    return parsedIndexes.map(function (chunk) {
      if (chunk[0] === "normal") {
        return h("span", {}, name.substring(chunk[1], chunk[2]));
      } else {
        return h("b", {}, name.substring(chunk[1], chunk[2]));
      }
    });
  }

  render(props, state) {
    return (
      h("li", null,
        h(
          "a",
          { href: props.result.item.link },
          this.renderName(props.result.item.name, props.result.matches[0].indices)
        )
      )
    );
  }
}

$(document).on("turbolinks:load", function () {
  var $fuzzies = $("[data-fuzzy]");
  var fuseOptions = {
    shouldSort: true,
    includeScore: true,
    includeMatches: true,
    threshold: 0.4,
    findAllMatches: true,
    minMatchCharLength: 1,
    maxPatternLength: 32,
    keys: ["name"]
  };

  $fuzzies.each(function (_, fuzzy) {
    var $fuzzy = $(fuzzy);
    var haystack = $fuzzy.data("fuzzy");
    var fuse = new Fuse(haystack, fuseOptions);
    var alreadyMountedChildren = $fuzzy.children();

    alreadyMountedChildren.each(function (_, alreadyMountedChild) {
      render("", fuzzy, alreadyMountedChild);
    });

    render(h(LinkSearch, { haystack: haystack, fuse: fuse }), fuzzy);
  });
});
