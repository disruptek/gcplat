
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Resource Views
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Resource View API allows users to create and manage logical sets of Google Compute Engine instances.
## 
## https://developers.google.com/compute/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "resourceviews"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ResourceviewsRegionViewsInsert_593980 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsRegionViewsInsert_593982(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/resourceViews")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsRegionViewsInsert_593981(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  ##   region: JString (required)
  ##         : The region name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `projectName` field"
  var valid_593983 = path.getOrDefault("projectName")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "projectName", valid_593983
  var valid_593984 = path.getOrDefault("region")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "region", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593985 = query.getOrDefault("fields")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "fields", valid_593985
  var valid_593986 = query.getOrDefault("quotaUser")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "quotaUser", valid_593986
  var valid_593987 = query.getOrDefault("alt")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = newJString("json"))
  if valid_593987 != nil:
    section.add "alt", valid_593987
  var valid_593988 = query.getOrDefault("oauth_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "oauth_token", valid_593988
  var valid_593989 = query.getOrDefault("userIp")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "userIp", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("prettyPrint")
  valid_593991 = validateParameter(valid_593991, JBool, required = false,
                                 default = newJBool(true))
  if valid_593991 != nil:
    section.add "prettyPrint", valid_593991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_ResourceviewsRegionViewsInsert_593980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource view.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_ResourceviewsRegionViewsInsert_593980;
          projectName: string; region: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## resourceviewsRegionViewsInsert
  ## Create a resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  var body_593997 = newJObject()
  add(query_593996, "fields", newJString(fields))
  add(query_593996, "quotaUser", newJString(quotaUser))
  add(query_593996, "alt", newJString(alt))
  add(query_593996, "oauth_token", newJString(oauthToken))
  add(query_593996, "userIp", newJString(userIp))
  add(query_593996, "key", newJString(key))
  add(path_593995, "projectName", newJString(projectName))
  add(path_593995, "region", newJString(region))
  if body != nil:
    body_593997 = body
  add(query_593996, "prettyPrint", newJBool(prettyPrint))
  result = call_593994.call(path_593995, query_593996, nil, nil, body_593997)

var resourceviewsRegionViewsInsert* = Call_ResourceviewsRegionViewsInsert_593980(
    name: "resourceviewsRegionViewsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews",
    validator: validate_ResourceviewsRegionViewsInsert_593981,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsInsert_593982, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsList_593692 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsRegionViewsList_593694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/resourceViews")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsRegionViewsList_593693(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List resource views.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  ##   region: JString (required)
  ##         : The region name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `projectName` field"
  var valid_593820 = path.getOrDefault("projectName")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "projectName", valid_593820
  var valid_593821 = path.getOrDefault("region")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "region", valid_593821
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593822 = query.getOrDefault("fields")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "fields", valid_593822
  var valid_593823 = query.getOrDefault("pageToken")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "pageToken", valid_593823
  var valid_593824 = query.getOrDefault("quotaUser")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "quotaUser", valid_593824
  var valid_593838 = query.getOrDefault("alt")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = newJString("json"))
  if valid_593838 != nil:
    section.add "alt", valid_593838
  var valid_593839 = query.getOrDefault("oauth_token")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "oauth_token", valid_593839
  var valid_593840 = query.getOrDefault("userIp")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "userIp", valid_593840
  var valid_593842 = query.getOrDefault("maxResults")
  valid_593842 = validateParameter(valid_593842, JInt, required = false,
                                 default = newJInt(5000))
  if valid_593842 != nil:
    section.add "maxResults", valid_593842
  var valid_593843 = query.getOrDefault("key")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = nil)
  if valid_593843 != nil:
    section.add "key", valid_593843
  var valid_593844 = query.getOrDefault("prettyPrint")
  valid_593844 = validateParameter(valid_593844, JBool, required = false,
                                 default = newJBool(true))
  if valid_593844 != nil:
    section.add "prettyPrint", valid_593844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593867: Call_ResourceviewsRegionViewsList_593692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List resource views.
  ## 
  let valid = call_593867.validator(path, query, header, formData, body)
  let scheme = call_593867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593867.url(scheme.get, call_593867.host, call_593867.base,
                         call_593867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593867, url, valid)

proc call*(call_593938: Call_ResourceviewsRegionViewsList_593692;
          projectName: string; region: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 5000;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## resourceviewsRegionViewsList
  ## List resource views.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593939 = newJObject()
  var query_593941 = newJObject()
  add(query_593941, "fields", newJString(fields))
  add(query_593941, "pageToken", newJString(pageToken))
  add(query_593941, "quotaUser", newJString(quotaUser))
  add(query_593941, "alt", newJString(alt))
  add(query_593941, "oauth_token", newJString(oauthToken))
  add(query_593941, "userIp", newJString(userIp))
  add(query_593941, "maxResults", newJInt(maxResults))
  add(query_593941, "key", newJString(key))
  add(path_593939, "projectName", newJString(projectName))
  add(path_593939, "region", newJString(region))
  add(query_593941, "prettyPrint", newJBool(prettyPrint))
  result = call_593938.call(path_593939, query_593941, nil, nil, nil)

var resourceviewsRegionViewsList* = Call_ResourceviewsRegionViewsList_593692(
    name: "resourceviewsRegionViewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews",
    validator: validate_ResourceviewsRegionViewsList_593693,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsList_593694, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsGet_593998 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsRegionViewsGet_594000(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "resourceViewName" in path,
        "`resourceViewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceViewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsRegionViewsGet_593999(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the information of a resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  ##   region: JString (required)
  ##         : The region name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_594001 = path.getOrDefault("resourceViewName")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "resourceViewName", valid_594001
  var valid_594002 = path.getOrDefault("projectName")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "projectName", valid_594002
  var valid_594003 = path.getOrDefault("region")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "region", valid_594003
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594004 = query.getOrDefault("fields")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "fields", valid_594004
  var valid_594005 = query.getOrDefault("quotaUser")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "quotaUser", valid_594005
  var valid_594006 = query.getOrDefault("alt")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = newJString("json"))
  if valid_594006 != nil:
    section.add "alt", valid_594006
  var valid_594007 = query.getOrDefault("oauth_token")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "oauth_token", valid_594007
  var valid_594008 = query.getOrDefault("userIp")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "userIp", valid_594008
  var valid_594009 = query.getOrDefault("key")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "key", valid_594009
  var valid_594010 = query.getOrDefault("prettyPrint")
  valid_594010 = validateParameter(valid_594010, JBool, required = false,
                                 default = newJBool(true))
  if valid_594010 != nil:
    section.add "prettyPrint", valid_594010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_ResourceviewsRegionViewsGet_593998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information of a resource view.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_ResourceviewsRegionViewsGet_593998;
          resourceViewName: string; projectName: string; region: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## resourceviewsRegionViewsGet
  ## Get the information of a resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  add(query_594014, "fields", newJString(fields))
  add(query_594014, "quotaUser", newJString(quotaUser))
  add(query_594014, "alt", newJString(alt))
  add(query_594014, "oauth_token", newJString(oauthToken))
  add(path_594013, "resourceViewName", newJString(resourceViewName))
  add(query_594014, "userIp", newJString(userIp))
  add(query_594014, "key", newJString(key))
  add(path_594013, "projectName", newJString(projectName))
  add(path_594013, "region", newJString(region))
  add(query_594014, "prettyPrint", newJBool(prettyPrint))
  result = call_594012.call(path_594013, query_594014, nil, nil, nil)

var resourceviewsRegionViewsGet* = Call_ResourceviewsRegionViewsGet_593998(
    name: "resourceviewsRegionViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsRegionViewsGet_593999,
    base: "/resourceviews/v1beta1/projects", url: url_ResourceviewsRegionViewsGet_594000,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsDelete_594015 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsRegionViewsDelete_594017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "resourceViewName" in path,
        "`resourceViewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceViewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsRegionViewsDelete_594016(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  ##   region: JString (required)
  ##         : The region name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_594018 = path.getOrDefault("resourceViewName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "resourceViewName", valid_594018
  var valid_594019 = path.getOrDefault("projectName")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "projectName", valid_594019
  var valid_594020 = path.getOrDefault("region")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "region", valid_594020
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594021 = query.getOrDefault("fields")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "fields", valid_594021
  var valid_594022 = query.getOrDefault("quotaUser")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "quotaUser", valid_594022
  var valid_594023 = query.getOrDefault("alt")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = newJString("json"))
  if valid_594023 != nil:
    section.add "alt", valid_594023
  var valid_594024 = query.getOrDefault("oauth_token")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "oauth_token", valid_594024
  var valid_594025 = query.getOrDefault("userIp")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "userIp", valid_594025
  var valid_594026 = query.getOrDefault("key")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "key", valid_594026
  var valid_594027 = query.getOrDefault("prettyPrint")
  valid_594027 = validateParameter(valid_594027, JBool, required = false,
                                 default = newJBool(true))
  if valid_594027 != nil:
    section.add "prettyPrint", valid_594027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594028: Call_ResourceviewsRegionViewsDelete_594015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a resource view.
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_ResourceviewsRegionViewsDelete_594015;
          resourceViewName: string; projectName: string; region: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## resourceviewsRegionViewsDelete
  ## Delete a resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  add(query_594031, "fields", newJString(fields))
  add(query_594031, "quotaUser", newJString(quotaUser))
  add(query_594031, "alt", newJString(alt))
  add(query_594031, "oauth_token", newJString(oauthToken))
  add(path_594030, "resourceViewName", newJString(resourceViewName))
  add(query_594031, "userIp", newJString(userIp))
  add(query_594031, "key", newJString(key))
  add(path_594030, "projectName", newJString(projectName))
  add(path_594030, "region", newJString(region))
  add(query_594031, "prettyPrint", newJBool(prettyPrint))
  result = call_594029.call(path_594030, query_594031, nil, nil, nil)

var resourceviewsRegionViewsDelete* = Call_ResourceviewsRegionViewsDelete_594015(
    name: "resourceviewsRegionViewsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsRegionViewsDelete_594016,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsDelete_594017, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsAddresources_594032 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsRegionViewsAddresources_594034(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "resourceViewName" in path,
        "`resourceViewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceViewName"),
               (kind: ConstantSegment, value: "/addResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsRegionViewsAddresources_594033(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add resources to the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  ##   region: JString (required)
  ##         : The region name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_594035 = path.getOrDefault("resourceViewName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "resourceViewName", valid_594035
  var valid_594036 = path.getOrDefault("projectName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "projectName", valid_594036
  var valid_594037 = path.getOrDefault("region")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "region", valid_594037
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594038 = query.getOrDefault("fields")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "fields", valid_594038
  var valid_594039 = query.getOrDefault("quotaUser")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "quotaUser", valid_594039
  var valid_594040 = query.getOrDefault("alt")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = newJString("json"))
  if valid_594040 != nil:
    section.add "alt", valid_594040
  var valid_594041 = query.getOrDefault("oauth_token")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "oauth_token", valid_594041
  var valid_594042 = query.getOrDefault("userIp")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "userIp", valid_594042
  var valid_594043 = query.getOrDefault("key")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "key", valid_594043
  var valid_594044 = query.getOrDefault("prettyPrint")
  valid_594044 = validateParameter(valid_594044, JBool, required = false,
                                 default = newJBool(true))
  if valid_594044 != nil:
    section.add "prettyPrint", valid_594044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_ResourceviewsRegionViewsAddresources_594032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add resources to the view.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_ResourceviewsRegionViewsAddresources_594032;
          resourceViewName: string; projectName: string; region: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## resourceviewsRegionViewsAddresources
  ## Add resources to the view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  var body_594050 = newJObject()
  add(query_594049, "fields", newJString(fields))
  add(query_594049, "quotaUser", newJString(quotaUser))
  add(query_594049, "alt", newJString(alt))
  add(query_594049, "oauth_token", newJString(oauthToken))
  add(path_594048, "resourceViewName", newJString(resourceViewName))
  add(query_594049, "userIp", newJString(userIp))
  add(query_594049, "key", newJString(key))
  add(path_594048, "projectName", newJString(projectName))
  add(path_594048, "region", newJString(region))
  if body != nil:
    body_594050 = body
  add(query_594049, "prettyPrint", newJBool(prettyPrint))
  result = call_594047.call(path_594048, query_594049, nil, nil, body_594050)

var resourceviewsRegionViewsAddresources* = Call_ResourceviewsRegionViewsAddresources_594032(
    name: "resourceviewsRegionViewsAddresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}/addResources",
    validator: validate_ResourceviewsRegionViewsAddresources_594033,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsAddresources_594034, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsRemoveresources_594051 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsRegionViewsRemoveresources_594053(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "resourceViewName" in path,
        "`resourceViewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceViewName"),
               (kind: ConstantSegment, value: "/removeResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsRegionViewsRemoveresources_594052(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove resources from the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  ##   region: JString (required)
  ##         : The region name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_594054 = path.getOrDefault("resourceViewName")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "resourceViewName", valid_594054
  var valid_594055 = path.getOrDefault("projectName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "projectName", valid_594055
  var valid_594056 = path.getOrDefault("region")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "region", valid_594056
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594057 = query.getOrDefault("fields")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "fields", valid_594057
  var valid_594058 = query.getOrDefault("quotaUser")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "quotaUser", valid_594058
  var valid_594059 = query.getOrDefault("alt")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = newJString("json"))
  if valid_594059 != nil:
    section.add "alt", valid_594059
  var valid_594060 = query.getOrDefault("oauth_token")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "oauth_token", valid_594060
  var valid_594061 = query.getOrDefault("userIp")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "userIp", valid_594061
  var valid_594062 = query.getOrDefault("key")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "key", valid_594062
  var valid_594063 = query.getOrDefault("prettyPrint")
  valid_594063 = validateParameter(valid_594063, JBool, required = false,
                                 default = newJBool(true))
  if valid_594063 != nil:
    section.add "prettyPrint", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594065: Call_ResourceviewsRegionViewsRemoveresources_594051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove resources from the view.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_ResourceviewsRegionViewsRemoveresources_594051;
          resourceViewName: string; projectName: string; region: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## resourceviewsRegionViewsRemoveresources
  ## Remove resources from the view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  var body_594069 = newJObject()
  add(query_594068, "fields", newJString(fields))
  add(query_594068, "quotaUser", newJString(quotaUser))
  add(query_594068, "alt", newJString(alt))
  add(query_594068, "oauth_token", newJString(oauthToken))
  add(path_594067, "resourceViewName", newJString(resourceViewName))
  add(query_594068, "userIp", newJString(userIp))
  add(query_594068, "key", newJString(key))
  add(path_594067, "projectName", newJString(projectName))
  add(path_594067, "region", newJString(region))
  if body != nil:
    body_594069 = body
  add(query_594068, "prettyPrint", newJBool(prettyPrint))
  result = call_594066.call(path_594067, query_594068, nil, nil, body_594069)

var resourceviewsRegionViewsRemoveresources* = Call_ResourceviewsRegionViewsRemoveresources_594051(
    name: "resourceviewsRegionViewsRemoveresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}/removeResources",
    validator: validate_ResourceviewsRegionViewsRemoveresources_594052,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsRemoveresources_594053,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsListresources_594070 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsRegionViewsListresources_594072(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "region" in path, "`region` is a required path parameter"
  assert "resourceViewName" in path,
        "`resourceViewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/regions/"),
               (kind: VariableSegment, value: "region"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceViewName"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsRegionViewsListresources_594071(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the resources in the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  ##   region: JString (required)
  ##         : The region name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_594073 = path.getOrDefault("resourceViewName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "resourceViewName", valid_594073
  var valid_594074 = path.getOrDefault("projectName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "projectName", valid_594074
  var valid_594075 = path.getOrDefault("region")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "region", valid_594075
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594076 = query.getOrDefault("fields")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "fields", valid_594076
  var valid_594077 = query.getOrDefault("pageToken")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "pageToken", valid_594077
  var valid_594078 = query.getOrDefault("quotaUser")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "quotaUser", valid_594078
  var valid_594079 = query.getOrDefault("alt")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = newJString("json"))
  if valid_594079 != nil:
    section.add "alt", valid_594079
  var valid_594080 = query.getOrDefault("oauth_token")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "oauth_token", valid_594080
  var valid_594081 = query.getOrDefault("userIp")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "userIp", valid_594081
  var valid_594082 = query.getOrDefault("maxResults")
  valid_594082 = validateParameter(valid_594082, JInt, required = false,
                                 default = newJInt(5000))
  if valid_594082 != nil:
    section.add "maxResults", valid_594082
  var valid_594083 = query.getOrDefault("key")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "key", valid_594083
  var valid_594084 = query.getOrDefault("prettyPrint")
  valid_594084 = validateParameter(valid_594084, JBool, required = false,
                                 default = newJBool(true))
  if valid_594084 != nil:
    section.add "prettyPrint", valid_594084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594085: Call_ResourceviewsRegionViewsListresources_594070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the resources in the view.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_ResourceviewsRegionViewsListresources_594070;
          resourceViewName: string; projectName: string; region: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5000; key: string = ""; prettyPrint: bool = true): Recallable =
  ## resourceviewsRegionViewsListresources
  ## List the resources in the view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  add(query_594088, "fields", newJString(fields))
  add(query_594088, "pageToken", newJString(pageToken))
  add(query_594088, "quotaUser", newJString(quotaUser))
  add(query_594088, "alt", newJString(alt))
  add(query_594088, "oauth_token", newJString(oauthToken))
  add(path_594087, "resourceViewName", newJString(resourceViewName))
  add(query_594088, "userIp", newJString(userIp))
  add(query_594088, "maxResults", newJInt(maxResults))
  add(query_594088, "key", newJString(key))
  add(path_594087, "projectName", newJString(projectName))
  add(path_594087, "region", newJString(region))
  add(query_594088, "prettyPrint", newJBool(prettyPrint))
  result = call_594086.call(path_594087, query_594088, nil, nil, nil)

var resourceviewsRegionViewsListresources* = Call_ResourceviewsRegionViewsListresources_594070(
    name: "resourceviewsRegionViewsListresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}/resources",
    validator: validate_ResourceviewsRegionViewsListresources_594071,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsListresources_594072, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsInsert_594107 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsZoneViewsInsert_594109(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsInsert_594108(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594110 = path.getOrDefault("zone")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "zone", valid_594110
  var valid_594111 = path.getOrDefault("projectName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "projectName", valid_594111
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594112 = query.getOrDefault("fields")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "fields", valid_594112
  var valid_594113 = query.getOrDefault("quotaUser")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "quotaUser", valid_594113
  var valid_594114 = query.getOrDefault("alt")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = newJString("json"))
  if valid_594114 != nil:
    section.add "alt", valid_594114
  var valid_594115 = query.getOrDefault("oauth_token")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "oauth_token", valid_594115
  var valid_594116 = query.getOrDefault("userIp")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "userIp", valid_594116
  var valid_594117 = query.getOrDefault("key")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "key", valid_594117
  var valid_594118 = query.getOrDefault("prettyPrint")
  valid_594118 = validateParameter(valid_594118, JBool, required = false,
                                 default = newJBool(true))
  if valid_594118 != nil:
    section.add "prettyPrint", valid_594118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594120: Call_ResourceviewsZoneViewsInsert_594107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource view.
  ## 
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_ResourceviewsZoneViewsInsert_594107; zone: string;
          projectName: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsInsert
  ## Create a resource view.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  var body_594124 = newJObject()
  add(path_594122, "zone", newJString(zone))
  add(query_594123, "fields", newJString(fields))
  add(query_594123, "quotaUser", newJString(quotaUser))
  add(query_594123, "alt", newJString(alt))
  add(query_594123, "oauth_token", newJString(oauthToken))
  add(query_594123, "userIp", newJString(userIp))
  add(query_594123, "key", newJString(key))
  add(path_594122, "projectName", newJString(projectName))
  if body != nil:
    body_594124 = body
  add(query_594123, "prettyPrint", newJBool(prettyPrint))
  result = call_594121.call(path_594122, query_594123, nil, nil, body_594124)

var resourceviewsZoneViewsInsert* = Call_ResourceviewsZoneViewsInsert_594107(
    name: "resourceviewsZoneViewsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews",
    validator: validate_ResourceviewsZoneViewsInsert_594108,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsInsert_594109, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsList_594089 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsZoneViewsList_594091(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsList_594090(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List resource views.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594092 = path.getOrDefault("zone")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "zone", valid_594092
  var valid_594093 = path.getOrDefault("projectName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "projectName", valid_594093
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594094 = query.getOrDefault("fields")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "fields", valid_594094
  var valid_594095 = query.getOrDefault("pageToken")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "pageToken", valid_594095
  var valid_594096 = query.getOrDefault("quotaUser")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "quotaUser", valid_594096
  var valid_594097 = query.getOrDefault("alt")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = newJString("json"))
  if valid_594097 != nil:
    section.add "alt", valid_594097
  var valid_594098 = query.getOrDefault("oauth_token")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "oauth_token", valid_594098
  var valid_594099 = query.getOrDefault("userIp")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "userIp", valid_594099
  var valid_594100 = query.getOrDefault("maxResults")
  valid_594100 = validateParameter(valid_594100, JInt, required = false,
                                 default = newJInt(5000))
  if valid_594100 != nil:
    section.add "maxResults", valid_594100
  var valid_594101 = query.getOrDefault("key")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "key", valid_594101
  var valid_594102 = query.getOrDefault("prettyPrint")
  valid_594102 = validateParameter(valid_594102, JBool, required = false,
                                 default = newJBool(true))
  if valid_594102 != nil:
    section.add "prettyPrint", valid_594102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594103: Call_ResourceviewsZoneViewsList_594089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List resource views.
  ## 
  let valid = call_594103.validator(path, query, header, formData, body)
  let scheme = call_594103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594103.url(scheme.get, call_594103.host, call_594103.base,
                         call_594103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594103, url, valid)

proc call*(call_594104: Call_ResourceviewsZoneViewsList_594089; zone: string;
          projectName: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 5000; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsList
  ## List resource views.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594105 = newJObject()
  var query_594106 = newJObject()
  add(path_594105, "zone", newJString(zone))
  add(query_594106, "fields", newJString(fields))
  add(query_594106, "pageToken", newJString(pageToken))
  add(query_594106, "quotaUser", newJString(quotaUser))
  add(query_594106, "alt", newJString(alt))
  add(query_594106, "oauth_token", newJString(oauthToken))
  add(query_594106, "userIp", newJString(userIp))
  add(query_594106, "maxResults", newJInt(maxResults))
  add(query_594106, "key", newJString(key))
  add(path_594105, "projectName", newJString(projectName))
  add(query_594106, "prettyPrint", newJBool(prettyPrint))
  result = call_594104.call(path_594105, query_594106, nil, nil, nil)

var resourceviewsZoneViewsList* = Call_ResourceviewsZoneViewsList_594089(
    name: "resourceviewsZoneViewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews",
    validator: validate_ResourceviewsZoneViewsList_594090,
    base: "/resourceviews/v1beta1/projects", url: url_ResourceviewsZoneViewsList_594091,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsGet_594125 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsZoneViewsGet_594127(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceViewName" in path,
        "`resourceViewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceViewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsGet_594126(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the information of a zonal resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594128 = path.getOrDefault("zone")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "zone", valid_594128
  var valid_594129 = path.getOrDefault("resourceViewName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "resourceViewName", valid_594129
  var valid_594130 = path.getOrDefault("projectName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "projectName", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594131 = query.getOrDefault("fields")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "fields", valid_594131
  var valid_594132 = query.getOrDefault("quotaUser")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "quotaUser", valid_594132
  var valid_594133 = query.getOrDefault("alt")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = newJString("json"))
  if valid_594133 != nil:
    section.add "alt", valid_594133
  var valid_594134 = query.getOrDefault("oauth_token")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "oauth_token", valid_594134
  var valid_594135 = query.getOrDefault("userIp")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "userIp", valid_594135
  var valid_594136 = query.getOrDefault("key")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "key", valid_594136
  var valid_594137 = query.getOrDefault("prettyPrint")
  valid_594137 = validateParameter(valid_594137, JBool, required = false,
                                 default = newJBool(true))
  if valid_594137 != nil:
    section.add "prettyPrint", valid_594137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594138: Call_ResourceviewsZoneViewsGet_594125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information of a zonal resource view.
  ## 
  let valid = call_594138.validator(path, query, header, formData, body)
  let scheme = call_594138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594138.url(scheme.get, call_594138.host, call_594138.base,
                         call_594138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594138, url, valid)

proc call*(call_594139: Call_ResourceviewsZoneViewsGet_594125; zone: string;
          resourceViewName: string; projectName: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsGet
  ## Get the information of a zonal resource view.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594140 = newJObject()
  var query_594141 = newJObject()
  add(path_594140, "zone", newJString(zone))
  add(query_594141, "fields", newJString(fields))
  add(query_594141, "quotaUser", newJString(quotaUser))
  add(query_594141, "alt", newJString(alt))
  add(query_594141, "oauth_token", newJString(oauthToken))
  add(path_594140, "resourceViewName", newJString(resourceViewName))
  add(query_594141, "userIp", newJString(userIp))
  add(query_594141, "key", newJString(key))
  add(path_594140, "projectName", newJString(projectName))
  add(query_594141, "prettyPrint", newJBool(prettyPrint))
  result = call_594139.call(path_594140, query_594141, nil, nil, nil)

var resourceviewsZoneViewsGet* = Call_ResourceviewsZoneViewsGet_594125(
    name: "resourceviewsZoneViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsZoneViewsGet_594126,
    base: "/resourceviews/v1beta1/projects", url: url_ResourceviewsZoneViewsGet_594127,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsDelete_594142 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsZoneViewsDelete_594144(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceViewName" in path,
        "`resourceViewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceViewName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsDelete_594143(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594145 = path.getOrDefault("zone")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "zone", valid_594145
  var valid_594146 = path.getOrDefault("resourceViewName")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "resourceViewName", valid_594146
  var valid_594147 = path.getOrDefault("projectName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "projectName", valid_594147
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594148 = query.getOrDefault("fields")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "fields", valid_594148
  var valid_594149 = query.getOrDefault("quotaUser")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "quotaUser", valid_594149
  var valid_594150 = query.getOrDefault("alt")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = newJString("json"))
  if valid_594150 != nil:
    section.add "alt", valid_594150
  var valid_594151 = query.getOrDefault("oauth_token")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "oauth_token", valid_594151
  var valid_594152 = query.getOrDefault("userIp")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "userIp", valid_594152
  var valid_594153 = query.getOrDefault("key")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "key", valid_594153
  var valid_594154 = query.getOrDefault("prettyPrint")
  valid_594154 = validateParameter(valid_594154, JBool, required = false,
                                 default = newJBool(true))
  if valid_594154 != nil:
    section.add "prettyPrint", valid_594154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594155: Call_ResourceviewsZoneViewsDelete_594142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a resource view.
  ## 
  let valid = call_594155.validator(path, query, header, formData, body)
  let scheme = call_594155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594155.url(scheme.get, call_594155.host, call_594155.base,
                         call_594155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594155, url, valid)

proc call*(call_594156: Call_ResourceviewsZoneViewsDelete_594142; zone: string;
          resourceViewName: string; projectName: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsDelete
  ## Delete a resource view.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594157 = newJObject()
  var query_594158 = newJObject()
  add(path_594157, "zone", newJString(zone))
  add(query_594158, "fields", newJString(fields))
  add(query_594158, "quotaUser", newJString(quotaUser))
  add(query_594158, "alt", newJString(alt))
  add(query_594158, "oauth_token", newJString(oauthToken))
  add(path_594157, "resourceViewName", newJString(resourceViewName))
  add(query_594158, "userIp", newJString(userIp))
  add(query_594158, "key", newJString(key))
  add(path_594157, "projectName", newJString(projectName))
  add(query_594158, "prettyPrint", newJBool(prettyPrint))
  result = call_594156.call(path_594157, query_594158, nil, nil, nil)

var resourceviewsZoneViewsDelete* = Call_ResourceviewsZoneViewsDelete_594142(
    name: "resourceviewsZoneViewsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsZoneViewsDelete_594143,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsDelete_594144, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsAddresources_594159 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsZoneViewsAddresources_594161(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceViewName" in path,
        "`resourceViewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceViewName"),
               (kind: ConstantSegment, value: "/addResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsAddresources_594160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add resources to the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594162 = path.getOrDefault("zone")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "zone", valid_594162
  var valid_594163 = path.getOrDefault("resourceViewName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "resourceViewName", valid_594163
  var valid_594164 = path.getOrDefault("projectName")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "projectName", valid_594164
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594165 = query.getOrDefault("fields")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "fields", valid_594165
  var valid_594166 = query.getOrDefault("quotaUser")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "quotaUser", valid_594166
  var valid_594167 = query.getOrDefault("alt")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = newJString("json"))
  if valid_594167 != nil:
    section.add "alt", valid_594167
  var valid_594168 = query.getOrDefault("oauth_token")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "oauth_token", valid_594168
  var valid_594169 = query.getOrDefault("userIp")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "userIp", valid_594169
  var valid_594170 = query.getOrDefault("key")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "key", valid_594170
  var valid_594171 = query.getOrDefault("prettyPrint")
  valid_594171 = validateParameter(valid_594171, JBool, required = false,
                                 default = newJBool(true))
  if valid_594171 != nil:
    section.add "prettyPrint", valid_594171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594173: Call_ResourceviewsZoneViewsAddresources_594159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add resources to the view.
  ## 
  let valid = call_594173.validator(path, query, header, formData, body)
  let scheme = call_594173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594173.url(scheme.get, call_594173.host, call_594173.base,
                         call_594173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594173, url, valid)

proc call*(call_594174: Call_ResourceviewsZoneViewsAddresources_594159;
          zone: string; resourceViewName: string; projectName: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsAddresources
  ## Add resources to the view.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594175 = newJObject()
  var query_594176 = newJObject()
  var body_594177 = newJObject()
  add(path_594175, "zone", newJString(zone))
  add(query_594176, "fields", newJString(fields))
  add(query_594176, "quotaUser", newJString(quotaUser))
  add(query_594176, "alt", newJString(alt))
  add(query_594176, "oauth_token", newJString(oauthToken))
  add(path_594175, "resourceViewName", newJString(resourceViewName))
  add(query_594176, "userIp", newJString(userIp))
  add(query_594176, "key", newJString(key))
  add(path_594175, "projectName", newJString(projectName))
  if body != nil:
    body_594177 = body
  add(query_594176, "prettyPrint", newJBool(prettyPrint))
  result = call_594174.call(path_594175, query_594176, nil, nil, body_594177)

var resourceviewsZoneViewsAddresources* = Call_ResourceviewsZoneViewsAddresources_594159(
    name: "resourceviewsZoneViewsAddresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}/addResources",
    validator: validate_ResourceviewsZoneViewsAddresources_594160,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsAddresources_594161, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsRemoveresources_594178 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsZoneViewsRemoveresources_594180(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceViewName" in path,
        "`resourceViewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceViewName"),
               (kind: ConstantSegment, value: "/removeResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsRemoveresources_594179(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove resources from the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594181 = path.getOrDefault("zone")
  valid_594181 = validateParameter(valid_594181, JString, required = true,
                                 default = nil)
  if valid_594181 != nil:
    section.add "zone", valid_594181
  var valid_594182 = path.getOrDefault("resourceViewName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "resourceViewName", valid_594182
  var valid_594183 = path.getOrDefault("projectName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "projectName", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594184 = query.getOrDefault("fields")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "fields", valid_594184
  var valid_594185 = query.getOrDefault("quotaUser")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "quotaUser", valid_594185
  var valid_594186 = query.getOrDefault("alt")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = newJString("json"))
  if valid_594186 != nil:
    section.add "alt", valid_594186
  var valid_594187 = query.getOrDefault("oauth_token")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "oauth_token", valid_594187
  var valid_594188 = query.getOrDefault("userIp")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "userIp", valid_594188
  var valid_594189 = query.getOrDefault("key")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "key", valid_594189
  var valid_594190 = query.getOrDefault("prettyPrint")
  valid_594190 = validateParameter(valid_594190, JBool, required = false,
                                 default = newJBool(true))
  if valid_594190 != nil:
    section.add "prettyPrint", valid_594190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594192: Call_ResourceviewsZoneViewsRemoveresources_594178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove resources from the view.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_ResourceviewsZoneViewsRemoveresources_594178;
          zone: string; resourceViewName: string; projectName: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsRemoveresources
  ## Remove resources from the view.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594194 = newJObject()
  var query_594195 = newJObject()
  var body_594196 = newJObject()
  add(path_594194, "zone", newJString(zone))
  add(query_594195, "fields", newJString(fields))
  add(query_594195, "quotaUser", newJString(quotaUser))
  add(query_594195, "alt", newJString(alt))
  add(query_594195, "oauth_token", newJString(oauthToken))
  add(path_594194, "resourceViewName", newJString(resourceViewName))
  add(query_594195, "userIp", newJString(userIp))
  add(query_594195, "key", newJString(key))
  add(path_594194, "projectName", newJString(projectName))
  if body != nil:
    body_594196 = body
  add(query_594195, "prettyPrint", newJBool(prettyPrint))
  result = call_594193.call(path_594194, query_594195, nil, nil, body_594196)

var resourceviewsZoneViewsRemoveresources* = Call_ResourceviewsZoneViewsRemoveresources_594178(
    name: "resourceviewsZoneViewsRemoveresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}/removeResources",
    validator: validate_ResourceviewsZoneViewsRemoveresources_594179,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsRemoveresources_594180, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsListresources_594197 = ref object of OpenApiRestCall_593424
proc url_ResourceviewsZoneViewsListresources_594199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectName" in path, "`projectName` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceViewName" in path,
        "`resourceViewName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "projectName"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceViewName"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsListresources_594198(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the resources of the resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_594200 = path.getOrDefault("zone")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "zone", valid_594200
  var valid_594201 = path.getOrDefault("resourceViewName")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "resourceViewName", valid_594201
  var valid_594202 = path.getOrDefault("projectName")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "projectName", valid_594202
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594203 = query.getOrDefault("fields")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "fields", valid_594203
  var valid_594204 = query.getOrDefault("pageToken")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "pageToken", valid_594204
  var valid_594205 = query.getOrDefault("quotaUser")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "quotaUser", valid_594205
  var valid_594206 = query.getOrDefault("alt")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = newJString("json"))
  if valid_594206 != nil:
    section.add "alt", valid_594206
  var valid_594207 = query.getOrDefault("oauth_token")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "oauth_token", valid_594207
  var valid_594208 = query.getOrDefault("userIp")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "userIp", valid_594208
  var valid_594209 = query.getOrDefault("maxResults")
  valid_594209 = validateParameter(valid_594209, JInt, required = false,
                                 default = newJInt(5000))
  if valid_594209 != nil:
    section.add "maxResults", valid_594209
  var valid_594210 = query.getOrDefault("key")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "key", valid_594210
  var valid_594211 = query.getOrDefault("prettyPrint")
  valid_594211 = validateParameter(valid_594211, JBool, required = false,
                                 default = newJBool(true))
  if valid_594211 != nil:
    section.add "prettyPrint", valid_594211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594212: Call_ResourceviewsZoneViewsListresources_594197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the resources of the resource view.
  ## 
  let valid = call_594212.validator(path, query, header, formData, body)
  let scheme = call_594212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594212.url(scheme.get, call_594212.host, call_594212.base,
                         call_594212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594212, url, valid)

proc call*(call_594213: Call_ResourceviewsZoneViewsListresources_594197;
          zone: string; resourceViewName: string; projectName: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5000; key: string = ""; prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsListresources
  ## List the resources of the resource view.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594214 = newJObject()
  var query_594215 = newJObject()
  add(path_594214, "zone", newJString(zone))
  add(query_594215, "fields", newJString(fields))
  add(query_594215, "pageToken", newJString(pageToken))
  add(query_594215, "quotaUser", newJString(quotaUser))
  add(query_594215, "alt", newJString(alt))
  add(query_594215, "oauth_token", newJString(oauthToken))
  add(path_594214, "resourceViewName", newJString(resourceViewName))
  add(query_594215, "userIp", newJString(userIp))
  add(query_594215, "maxResults", newJInt(maxResults))
  add(query_594215, "key", newJString(key))
  add(path_594214, "projectName", newJString(projectName))
  add(query_594215, "prettyPrint", newJBool(prettyPrint))
  result = call_594213.call(path_594214, query_594215, nil, nil, nil)

var resourceviewsZoneViewsListresources* = Call_ResourceviewsZoneViewsListresources_594197(
    name: "resourceviewsZoneViewsListresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}/resources",
    validator: validate_ResourceviewsZoneViewsListresources_594198,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsListresources_594199, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
