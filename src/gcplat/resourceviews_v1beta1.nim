
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ResourceviewsRegionViewsInsert_579980 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsRegionViewsInsert_579982(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsRegionViewsInsert_579981(path: JsonNode;
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
  var valid_579983 = path.getOrDefault("projectName")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "projectName", valid_579983
  var valid_579984 = path.getOrDefault("region")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "region", valid_579984
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
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("alt")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = newJString("json"))
  if valid_579987 != nil:
    section.add "alt", valid_579987
  var valid_579988 = query.getOrDefault("oauth_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "oauth_token", valid_579988
  var valid_579989 = query.getOrDefault("userIp")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "userIp", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("prettyPrint")
  valid_579991 = validateParameter(valid_579991, JBool, required = false,
                                 default = newJBool(true))
  if valid_579991 != nil:
    section.add "prettyPrint", valid_579991
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

proc call*(call_579993: Call_ResourceviewsRegionViewsInsert_579980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource view.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_ResourceviewsRegionViewsInsert_579980;
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
  var path_579995 = newJObject()
  var query_579996 = newJObject()
  var body_579997 = newJObject()
  add(query_579996, "fields", newJString(fields))
  add(query_579996, "quotaUser", newJString(quotaUser))
  add(query_579996, "alt", newJString(alt))
  add(query_579996, "oauth_token", newJString(oauthToken))
  add(query_579996, "userIp", newJString(userIp))
  add(query_579996, "key", newJString(key))
  add(path_579995, "projectName", newJString(projectName))
  add(path_579995, "region", newJString(region))
  if body != nil:
    body_579997 = body
  add(query_579996, "prettyPrint", newJBool(prettyPrint))
  result = call_579994.call(path_579995, query_579996, nil, nil, body_579997)

var resourceviewsRegionViewsInsert* = Call_ResourceviewsRegionViewsInsert_579980(
    name: "resourceviewsRegionViewsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews",
    validator: validate_ResourceviewsRegionViewsInsert_579981,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsInsert_579982, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsList_579692 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsRegionViewsList_579694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsRegionViewsList_579693(path: JsonNode; query: JsonNode;
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
  var valid_579820 = path.getOrDefault("projectName")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "projectName", valid_579820
  var valid_579821 = path.getOrDefault("region")
  valid_579821 = validateParameter(valid_579821, JString, required = true,
                                 default = nil)
  if valid_579821 != nil:
    section.add "region", valid_579821
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
  var valid_579822 = query.getOrDefault("fields")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "fields", valid_579822
  var valid_579823 = query.getOrDefault("pageToken")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "pageToken", valid_579823
  var valid_579824 = query.getOrDefault("quotaUser")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "quotaUser", valid_579824
  var valid_579838 = query.getOrDefault("alt")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = newJString("json"))
  if valid_579838 != nil:
    section.add "alt", valid_579838
  var valid_579839 = query.getOrDefault("oauth_token")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "oauth_token", valid_579839
  var valid_579840 = query.getOrDefault("userIp")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "userIp", valid_579840
  var valid_579842 = query.getOrDefault("maxResults")
  valid_579842 = validateParameter(valid_579842, JInt, required = false,
                                 default = newJInt(5000))
  if valid_579842 != nil:
    section.add "maxResults", valid_579842
  var valid_579843 = query.getOrDefault("key")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = nil)
  if valid_579843 != nil:
    section.add "key", valid_579843
  var valid_579844 = query.getOrDefault("prettyPrint")
  valid_579844 = validateParameter(valid_579844, JBool, required = false,
                                 default = newJBool(true))
  if valid_579844 != nil:
    section.add "prettyPrint", valid_579844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579867: Call_ResourceviewsRegionViewsList_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List resource views.
  ## 
  let valid = call_579867.validator(path, query, header, formData, body)
  let scheme = call_579867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579867.url(scheme.get, call_579867.host, call_579867.base,
                         call_579867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579867, url, valid)

proc call*(call_579938: Call_ResourceviewsRegionViewsList_579692;
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
  var path_579939 = newJObject()
  var query_579941 = newJObject()
  add(query_579941, "fields", newJString(fields))
  add(query_579941, "pageToken", newJString(pageToken))
  add(query_579941, "quotaUser", newJString(quotaUser))
  add(query_579941, "alt", newJString(alt))
  add(query_579941, "oauth_token", newJString(oauthToken))
  add(query_579941, "userIp", newJString(userIp))
  add(query_579941, "maxResults", newJInt(maxResults))
  add(query_579941, "key", newJString(key))
  add(path_579939, "projectName", newJString(projectName))
  add(path_579939, "region", newJString(region))
  add(query_579941, "prettyPrint", newJBool(prettyPrint))
  result = call_579938.call(path_579939, query_579941, nil, nil, nil)

var resourceviewsRegionViewsList* = Call_ResourceviewsRegionViewsList_579692(
    name: "resourceviewsRegionViewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews",
    validator: validate_ResourceviewsRegionViewsList_579693,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsList_579694, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsGet_579998 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsRegionViewsGet_580000(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsRegionViewsGet_579999(path: JsonNode; query: JsonNode;
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
  var valid_580001 = path.getOrDefault("resourceViewName")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = nil)
  if valid_580001 != nil:
    section.add "resourceViewName", valid_580001
  var valid_580002 = path.getOrDefault("projectName")
  valid_580002 = validateParameter(valid_580002, JString, required = true,
                                 default = nil)
  if valid_580002 != nil:
    section.add "projectName", valid_580002
  var valid_580003 = path.getOrDefault("region")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "region", valid_580003
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
  var valid_580004 = query.getOrDefault("fields")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "fields", valid_580004
  var valid_580005 = query.getOrDefault("quotaUser")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "quotaUser", valid_580005
  var valid_580006 = query.getOrDefault("alt")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = newJString("json"))
  if valid_580006 != nil:
    section.add "alt", valid_580006
  var valid_580007 = query.getOrDefault("oauth_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "oauth_token", valid_580007
  var valid_580008 = query.getOrDefault("userIp")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "userIp", valid_580008
  var valid_580009 = query.getOrDefault("key")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "key", valid_580009
  var valid_580010 = query.getOrDefault("prettyPrint")
  valid_580010 = validateParameter(valid_580010, JBool, required = false,
                                 default = newJBool(true))
  if valid_580010 != nil:
    section.add "prettyPrint", valid_580010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580011: Call_ResourceviewsRegionViewsGet_579998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information of a resource view.
  ## 
  let valid = call_580011.validator(path, query, header, formData, body)
  let scheme = call_580011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580011.url(scheme.get, call_580011.host, call_580011.base,
                         call_580011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580011, url, valid)

proc call*(call_580012: Call_ResourceviewsRegionViewsGet_579998;
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
  var path_580013 = newJObject()
  var query_580014 = newJObject()
  add(query_580014, "fields", newJString(fields))
  add(query_580014, "quotaUser", newJString(quotaUser))
  add(query_580014, "alt", newJString(alt))
  add(query_580014, "oauth_token", newJString(oauthToken))
  add(path_580013, "resourceViewName", newJString(resourceViewName))
  add(query_580014, "userIp", newJString(userIp))
  add(query_580014, "key", newJString(key))
  add(path_580013, "projectName", newJString(projectName))
  add(path_580013, "region", newJString(region))
  add(query_580014, "prettyPrint", newJBool(prettyPrint))
  result = call_580012.call(path_580013, query_580014, nil, nil, nil)

var resourceviewsRegionViewsGet* = Call_ResourceviewsRegionViewsGet_579998(
    name: "resourceviewsRegionViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsRegionViewsGet_579999,
    base: "/resourceviews/v1beta1/projects", url: url_ResourceviewsRegionViewsGet_580000,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsDelete_580015 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsRegionViewsDelete_580017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsRegionViewsDelete_580016(path: JsonNode;
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
  var valid_580018 = path.getOrDefault("resourceViewName")
  valid_580018 = validateParameter(valid_580018, JString, required = true,
                                 default = nil)
  if valid_580018 != nil:
    section.add "resourceViewName", valid_580018
  var valid_580019 = path.getOrDefault("projectName")
  valid_580019 = validateParameter(valid_580019, JString, required = true,
                                 default = nil)
  if valid_580019 != nil:
    section.add "projectName", valid_580019
  var valid_580020 = path.getOrDefault("region")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "region", valid_580020
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
  var valid_580021 = query.getOrDefault("fields")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "fields", valid_580021
  var valid_580022 = query.getOrDefault("quotaUser")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "quotaUser", valid_580022
  var valid_580023 = query.getOrDefault("alt")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("json"))
  if valid_580023 != nil:
    section.add "alt", valid_580023
  var valid_580024 = query.getOrDefault("oauth_token")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "oauth_token", valid_580024
  var valid_580025 = query.getOrDefault("userIp")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "userIp", valid_580025
  var valid_580026 = query.getOrDefault("key")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "key", valid_580026
  var valid_580027 = query.getOrDefault("prettyPrint")
  valid_580027 = validateParameter(valid_580027, JBool, required = false,
                                 default = newJBool(true))
  if valid_580027 != nil:
    section.add "prettyPrint", valid_580027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580028: Call_ResourceviewsRegionViewsDelete_580015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a resource view.
  ## 
  let valid = call_580028.validator(path, query, header, formData, body)
  let scheme = call_580028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580028.url(scheme.get, call_580028.host, call_580028.base,
                         call_580028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580028, url, valid)

proc call*(call_580029: Call_ResourceviewsRegionViewsDelete_580015;
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
  var path_580030 = newJObject()
  var query_580031 = newJObject()
  add(query_580031, "fields", newJString(fields))
  add(query_580031, "quotaUser", newJString(quotaUser))
  add(query_580031, "alt", newJString(alt))
  add(query_580031, "oauth_token", newJString(oauthToken))
  add(path_580030, "resourceViewName", newJString(resourceViewName))
  add(query_580031, "userIp", newJString(userIp))
  add(query_580031, "key", newJString(key))
  add(path_580030, "projectName", newJString(projectName))
  add(path_580030, "region", newJString(region))
  add(query_580031, "prettyPrint", newJBool(prettyPrint))
  result = call_580029.call(path_580030, query_580031, nil, nil, nil)

var resourceviewsRegionViewsDelete* = Call_ResourceviewsRegionViewsDelete_580015(
    name: "resourceviewsRegionViewsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsRegionViewsDelete_580016,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsDelete_580017, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsAddresources_580032 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsRegionViewsAddresources_580034(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsRegionViewsAddresources_580033(path: JsonNode;
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
  var valid_580035 = path.getOrDefault("resourceViewName")
  valid_580035 = validateParameter(valid_580035, JString, required = true,
                                 default = nil)
  if valid_580035 != nil:
    section.add "resourceViewName", valid_580035
  var valid_580036 = path.getOrDefault("projectName")
  valid_580036 = validateParameter(valid_580036, JString, required = true,
                                 default = nil)
  if valid_580036 != nil:
    section.add "projectName", valid_580036
  var valid_580037 = path.getOrDefault("region")
  valid_580037 = validateParameter(valid_580037, JString, required = true,
                                 default = nil)
  if valid_580037 != nil:
    section.add "region", valid_580037
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
  var valid_580038 = query.getOrDefault("fields")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "fields", valid_580038
  var valid_580039 = query.getOrDefault("quotaUser")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "quotaUser", valid_580039
  var valid_580040 = query.getOrDefault("alt")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = newJString("json"))
  if valid_580040 != nil:
    section.add "alt", valid_580040
  var valid_580041 = query.getOrDefault("oauth_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "oauth_token", valid_580041
  var valid_580042 = query.getOrDefault("userIp")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "userIp", valid_580042
  var valid_580043 = query.getOrDefault("key")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "key", valid_580043
  var valid_580044 = query.getOrDefault("prettyPrint")
  valid_580044 = validateParameter(valid_580044, JBool, required = false,
                                 default = newJBool(true))
  if valid_580044 != nil:
    section.add "prettyPrint", valid_580044
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

proc call*(call_580046: Call_ResourceviewsRegionViewsAddresources_580032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add resources to the view.
  ## 
  let valid = call_580046.validator(path, query, header, formData, body)
  let scheme = call_580046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580046.url(scheme.get, call_580046.host, call_580046.base,
                         call_580046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580046, url, valid)

proc call*(call_580047: Call_ResourceviewsRegionViewsAddresources_580032;
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
  var path_580048 = newJObject()
  var query_580049 = newJObject()
  var body_580050 = newJObject()
  add(query_580049, "fields", newJString(fields))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(query_580049, "alt", newJString(alt))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(path_580048, "resourceViewName", newJString(resourceViewName))
  add(query_580049, "userIp", newJString(userIp))
  add(query_580049, "key", newJString(key))
  add(path_580048, "projectName", newJString(projectName))
  add(path_580048, "region", newJString(region))
  if body != nil:
    body_580050 = body
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  result = call_580047.call(path_580048, query_580049, nil, nil, body_580050)

var resourceviewsRegionViewsAddresources* = Call_ResourceviewsRegionViewsAddresources_580032(
    name: "resourceviewsRegionViewsAddresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}/addResources",
    validator: validate_ResourceviewsRegionViewsAddresources_580033,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsAddresources_580034, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsRemoveresources_580051 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsRegionViewsRemoveresources_580053(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsRegionViewsRemoveresources_580052(path: JsonNode;
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
  var valid_580054 = path.getOrDefault("resourceViewName")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "resourceViewName", valid_580054
  var valid_580055 = path.getOrDefault("projectName")
  valid_580055 = validateParameter(valid_580055, JString, required = true,
                                 default = nil)
  if valid_580055 != nil:
    section.add "projectName", valid_580055
  var valid_580056 = path.getOrDefault("region")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "region", valid_580056
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
  var valid_580057 = query.getOrDefault("fields")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "fields", valid_580057
  var valid_580058 = query.getOrDefault("quotaUser")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "quotaUser", valid_580058
  var valid_580059 = query.getOrDefault("alt")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("json"))
  if valid_580059 != nil:
    section.add "alt", valid_580059
  var valid_580060 = query.getOrDefault("oauth_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "oauth_token", valid_580060
  var valid_580061 = query.getOrDefault("userIp")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "userIp", valid_580061
  var valid_580062 = query.getOrDefault("key")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "key", valid_580062
  var valid_580063 = query.getOrDefault("prettyPrint")
  valid_580063 = validateParameter(valid_580063, JBool, required = false,
                                 default = newJBool(true))
  if valid_580063 != nil:
    section.add "prettyPrint", valid_580063
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

proc call*(call_580065: Call_ResourceviewsRegionViewsRemoveresources_580051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove resources from the view.
  ## 
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_ResourceviewsRegionViewsRemoveresources_580051;
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
  var path_580067 = newJObject()
  var query_580068 = newJObject()
  var body_580069 = newJObject()
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(path_580067, "resourceViewName", newJString(resourceViewName))
  add(query_580068, "userIp", newJString(userIp))
  add(query_580068, "key", newJString(key))
  add(path_580067, "projectName", newJString(projectName))
  add(path_580067, "region", newJString(region))
  if body != nil:
    body_580069 = body
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  result = call_580066.call(path_580067, query_580068, nil, nil, body_580069)

var resourceviewsRegionViewsRemoveresources* = Call_ResourceviewsRegionViewsRemoveresources_580051(
    name: "resourceviewsRegionViewsRemoveresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}/removeResources",
    validator: validate_ResourceviewsRegionViewsRemoveresources_580052,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsRemoveresources_580053,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsListresources_580070 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsRegionViewsListresources_580072(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsRegionViewsListresources_580071(path: JsonNode;
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
  var valid_580073 = path.getOrDefault("resourceViewName")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "resourceViewName", valid_580073
  var valid_580074 = path.getOrDefault("projectName")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "projectName", valid_580074
  var valid_580075 = path.getOrDefault("region")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "region", valid_580075
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
  var valid_580076 = query.getOrDefault("fields")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "fields", valid_580076
  var valid_580077 = query.getOrDefault("pageToken")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "pageToken", valid_580077
  var valid_580078 = query.getOrDefault("quotaUser")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "quotaUser", valid_580078
  var valid_580079 = query.getOrDefault("alt")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = newJString("json"))
  if valid_580079 != nil:
    section.add "alt", valid_580079
  var valid_580080 = query.getOrDefault("oauth_token")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "oauth_token", valid_580080
  var valid_580081 = query.getOrDefault("userIp")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "userIp", valid_580081
  var valid_580082 = query.getOrDefault("maxResults")
  valid_580082 = validateParameter(valid_580082, JInt, required = false,
                                 default = newJInt(5000))
  if valid_580082 != nil:
    section.add "maxResults", valid_580082
  var valid_580083 = query.getOrDefault("key")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "key", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(true))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580085: Call_ResourceviewsRegionViewsListresources_580070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the resources in the view.
  ## 
  let valid = call_580085.validator(path, query, header, formData, body)
  let scheme = call_580085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580085.url(scheme.get, call_580085.host, call_580085.base,
                         call_580085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580085, url, valid)

proc call*(call_580086: Call_ResourceviewsRegionViewsListresources_580070;
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
  var path_580087 = newJObject()
  var query_580088 = newJObject()
  add(query_580088, "fields", newJString(fields))
  add(query_580088, "pageToken", newJString(pageToken))
  add(query_580088, "quotaUser", newJString(quotaUser))
  add(query_580088, "alt", newJString(alt))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(path_580087, "resourceViewName", newJString(resourceViewName))
  add(query_580088, "userIp", newJString(userIp))
  add(query_580088, "maxResults", newJInt(maxResults))
  add(query_580088, "key", newJString(key))
  add(path_580087, "projectName", newJString(projectName))
  add(path_580087, "region", newJString(region))
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  result = call_580086.call(path_580087, query_580088, nil, nil, nil)

var resourceviewsRegionViewsListresources* = Call_ResourceviewsRegionViewsListresources_580070(
    name: "resourceviewsRegionViewsListresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}/resources",
    validator: validate_ResourceviewsRegionViewsListresources_580071,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsListresources_580072, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsInsert_580107 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsInsert_580109(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsZoneViewsInsert_580108(path: JsonNode; query: JsonNode;
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
  var valid_580110 = path.getOrDefault("zone")
  valid_580110 = validateParameter(valid_580110, JString, required = true,
                                 default = nil)
  if valid_580110 != nil:
    section.add "zone", valid_580110
  var valid_580111 = path.getOrDefault("projectName")
  valid_580111 = validateParameter(valid_580111, JString, required = true,
                                 default = nil)
  if valid_580111 != nil:
    section.add "projectName", valid_580111
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
  var valid_580112 = query.getOrDefault("fields")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "fields", valid_580112
  var valid_580113 = query.getOrDefault("quotaUser")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "quotaUser", valid_580113
  var valid_580114 = query.getOrDefault("alt")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = newJString("json"))
  if valid_580114 != nil:
    section.add "alt", valid_580114
  var valid_580115 = query.getOrDefault("oauth_token")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "oauth_token", valid_580115
  var valid_580116 = query.getOrDefault("userIp")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "userIp", valid_580116
  var valid_580117 = query.getOrDefault("key")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "key", valid_580117
  var valid_580118 = query.getOrDefault("prettyPrint")
  valid_580118 = validateParameter(valid_580118, JBool, required = false,
                                 default = newJBool(true))
  if valid_580118 != nil:
    section.add "prettyPrint", valid_580118
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

proc call*(call_580120: Call_ResourceviewsZoneViewsInsert_580107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource view.
  ## 
  let valid = call_580120.validator(path, query, header, formData, body)
  let scheme = call_580120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580120.url(scheme.get, call_580120.host, call_580120.base,
                         call_580120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580120, url, valid)

proc call*(call_580121: Call_ResourceviewsZoneViewsInsert_580107; zone: string;
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
  var path_580122 = newJObject()
  var query_580123 = newJObject()
  var body_580124 = newJObject()
  add(path_580122, "zone", newJString(zone))
  add(query_580123, "fields", newJString(fields))
  add(query_580123, "quotaUser", newJString(quotaUser))
  add(query_580123, "alt", newJString(alt))
  add(query_580123, "oauth_token", newJString(oauthToken))
  add(query_580123, "userIp", newJString(userIp))
  add(query_580123, "key", newJString(key))
  add(path_580122, "projectName", newJString(projectName))
  if body != nil:
    body_580124 = body
  add(query_580123, "prettyPrint", newJBool(prettyPrint))
  result = call_580121.call(path_580122, query_580123, nil, nil, body_580124)

var resourceviewsZoneViewsInsert* = Call_ResourceviewsZoneViewsInsert_580107(
    name: "resourceviewsZoneViewsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews",
    validator: validate_ResourceviewsZoneViewsInsert_580108,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsInsert_580109, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsList_580089 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsList_580091(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsZoneViewsList_580090(path: JsonNode; query: JsonNode;
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
  var valid_580092 = path.getOrDefault("zone")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "zone", valid_580092
  var valid_580093 = path.getOrDefault("projectName")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "projectName", valid_580093
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
  var valid_580094 = query.getOrDefault("fields")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "fields", valid_580094
  var valid_580095 = query.getOrDefault("pageToken")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "pageToken", valid_580095
  var valid_580096 = query.getOrDefault("quotaUser")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "quotaUser", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("oauth_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "oauth_token", valid_580098
  var valid_580099 = query.getOrDefault("userIp")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "userIp", valid_580099
  var valid_580100 = query.getOrDefault("maxResults")
  valid_580100 = validateParameter(valid_580100, JInt, required = false,
                                 default = newJInt(5000))
  if valid_580100 != nil:
    section.add "maxResults", valid_580100
  var valid_580101 = query.getOrDefault("key")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "key", valid_580101
  var valid_580102 = query.getOrDefault("prettyPrint")
  valid_580102 = validateParameter(valid_580102, JBool, required = false,
                                 default = newJBool(true))
  if valid_580102 != nil:
    section.add "prettyPrint", valid_580102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580103: Call_ResourceviewsZoneViewsList_580089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List resource views.
  ## 
  let valid = call_580103.validator(path, query, header, formData, body)
  let scheme = call_580103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580103.url(scheme.get, call_580103.host, call_580103.base,
                         call_580103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580103, url, valid)

proc call*(call_580104: Call_ResourceviewsZoneViewsList_580089; zone: string;
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
  var path_580105 = newJObject()
  var query_580106 = newJObject()
  add(path_580105, "zone", newJString(zone))
  add(query_580106, "fields", newJString(fields))
  add(query_580106, "pageToken", newJString(pageToken))
  add(query_580106, "quotaUser", newJString(quotaUser))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(query_580106, "userIp", newJString(userIp))
  add(query_580106, "maxResults", newJInt(maxResults))
  add(query_580106, "key", newJString(key))
  add(path_580105, "projectName", newJString(projectName))
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  result = call_580104.call(path_580105, query_580106, nil, nil, nil)

var resourceviewsZoneViewsList* = Call_ResourceviewsZoneViewsList_580089(
    name: "resourceviewsZoneViewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews",
    validator: validate_ResourceviewsZoneViewsList_580090,
    base: "/resourceviews/v1beta1/projects", url: url_ResourceviewsZoneViewsList_580091,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsGet_580125 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsGet_580127(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsZoneViewsGet_580126(path: JsonNode; query: JsonNode;
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
  var valid_580128 = path.getOrDefault("zone")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "zone", valid_580128
  var valid_580129 = path.getOrDefault("resourceViewName")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "resourceViewName", valid_580129
  var valid_580130 = path.getOrDefault("projectName")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "projectName", valid_580130
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
  var valid_580131 = query.getOrDefault("fields")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "fields", valid_580131
  var valid_580132 = query.getOrDefault("quotaUser")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "quotaUser", valid_580132
  var valid_580133 = query.getOrDefault("alt")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = newJString("json"))
  if valid_580133 != nil:
    section.add "alt", valid_580133
  var valid_580134 = query.getOrDefault("oauth_token")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "oauth_token", valid_580134
  var valid_580135 = query.getOrDefault("userIp")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "userIp", valid_580135
  var valid_580136 = query.getOrDefault("key")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "key", valid_580136
  var valid_580137 = query.getOrDefault("prettyPrint")
  valid_580137 = validateParameter(valid_580137, JBool, required = false,
                                 default = newJBool(true))
  if valid_580137 != nil:
    section.add "prettyPrint", valid_580137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580138: Call_ResourceviewsZoneViewsGet_580125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information of a zonal resource view.
  ## 
  let valid = call_580138.validator(path, query, header, formData, body)
  let scheme = call_580138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580138.url(scheme.get, call_580138.host, call_580138.base,
                         call_580138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580138, url, valid)

proc call*(call_580139: Call_ResourceviewsZoneViewsGet_580125; zone: string;
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
  var path_580140 = newJObject()
  var query_580141 = newJObject()
  add(path_580140, "zone", newJString(zone))
  add(query_580141, "fields", newJString(fields))
  add(query_580141, "quotaUser", newJString(quotaUser))
  add(query_580141, "alt", newJString(alt))
  add(query_580141, "oauth_token", newJString(oauthToken))
  add(path_580140, "resourceViewName", newJString(resourceViewName))
  add(query_580141, "userIp", newJString(userIp))
  add(query_580141, "key", newJString(key))
  add(path_580140, "projectName", newJString(projectName))
  add(query_580141, "prettyPrint", newJBool(prettyPrint))
  result = call_580139.call(path_580140, query_580141, nil, nil, nil)

var resourceviewsZoneViewsGet* = Call_ResourceviewsZoneViewsGet_580125(
    name: "resourceviewsZoneViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsZoneViewsGet_580126,
    base: "/resourceviews/v1beta1/projects", url: url_ResourceviewsZoneViewsGet_580127,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsDelete_580142 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsDelete_580144(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsZoneViewsDelete_580143(path: JsonNode; query: JsonNode;
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
  var valid_580145 = path.getOrDefault("zone")
  valid_580145 = validateParameter(valid_580145, JString, required = true,
                                 default = nil)
  if valid_580145 != nil:
    section.add "zone", valid_580145
  var valid_580146 = path.getOrDefault("resourceViewName")
  valid_580146 = validateParameter(valid_580146, JString, required = true,
                                 default = nil)
  if valid_580146 != nil:
    section.add "resourceViewName", valid_580146
  var valid_580147 = path.getOrDefault("projectName")
  valid_580147 = validateParameter(valid_580147, JString, required = true,
                                 default = nil)
  if valid_580147 != nil:
    section.add "projectName", valid_580147
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
  var valid_580148 = query.getOrDefault("fields")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "fields", valid_580148
  var valid_580149 = query.getOrDefault("quotaUser")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "quotaUser", valid_580149
  var valid_580150 = query.getOrDefault("alt")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("json"))
  if valid_580150 != nil:
    section.add "alt", valid_580150
  var valid_580151 = query.getOrDefault("oauth_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "oauth_token", valid_580151
  var valid_580152 = query.getOrDefault("userIp")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "userIp", valid_580152
  var valid_580153 = query.getOrDefault("key")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "key", valid_580153
  var valid_580154 = query.getOrDefault("prettyPrint")
  valid_580154 = validateParameter(valid_580154, JBool, required = false,
                                 default = newJBool(true))
  if valid_580154 != nil:
    section.add "prettyPrint", valid_580154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580155: Call_ResourceviewsZoneViewsDelete_580142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a resource view.
  ## 
  let valid = call_580155.validator(path, query, header, formData, body)
  let scheme = call_580155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580155.url(scheme.get, call_580155.host, call_580155.base,
                         call_580155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580155, url, valid)

proc call*(call_580156: Call_ResourceviewsZoneViewsDelete_580142; zone: string;
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
  var path_580157 = newJObject()
  var query_580158 = newJObject()
  add(path_580157, "zone", newJString(zone))
  add(query_580158, "fields", newJString(fields))
  add(query_580158, "quotaUser", newJString(quotaUser))
  add(query_580158, "alt", newJString(alt))
  add(query_580158, "oauth_token", newJString(oauthToken))
  add(path_580157, "resourceViewName", newJString(resourceViewName))
  add(query_580158, "userIp", newJString(userIp))
  add(query_580158, "key", newJString(key))
  add(path_580157, "projectName", newJString(projectName))
  add(query_580158, "prettyPrint", newJBool(prettyPrint))
  result = call_580156.call(path_580157, query_580158, nil, nil, nil)

var resourceviewsZoneViewsDelete* = Call_ResourceviewsZoneViewsDelete_580142(
    name: "resourceviewsZoneViewsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsZoneViewsDelete_580143,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsDelete_580144, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsAddresources_580159 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsAddresources_580161(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsZoneViewsAddresources_580160(path: JsonNode;
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
  var valid_580162 = path.getOrDefault("zone")
  valid_580162 = validateParameter(valid_580162, JString, required = true,
                                 default = nil)
  if valid_580162 != nil:
    section.add "zone", valid_580162
  var valid_580163 = path.getOrDefault("resourceViewName")
  valid_580163 = validateParameter(valid_580163, JString, required = true,
                                 default = nil)
  if valid_580163 != nil:
    section.add "resourceViewName", valid_580163
  var valid_580164 = path.getOrDefault("projectName")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "projectName", valid_580164
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
  var valid_580165 = query.getOrDefault("fields")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "fields", valid_580165
  var valid_580166 = query.getOrDefault("quotaUser")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "quotaUser", valid_580166
  var valid_580167 = query.getOrDefault("alt")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = newJString("json"))
  if valid_580167 != nil:
    section.add "alt", valid_580167
  var valid_580168 = query.getOrDefault("oauth_token")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "oauth_token", valid_580168
  var valid_580169 = query.getOrDefault("userIp")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "userIp", valid_580169
  var valid_580170 = query.getOrDefault("key")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "key", valid_580170
  var valid_580171 = query.getOrDefault("prettyPrint")
  valid_580171 = validateParameter(valid_580171, JBool, required = false,
                                 default = newJBool(true))
  if valid_580171 != nil:
    section.add "prettyPrint", valid_580171
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

proc call*(call_580173: Call_ResourceviewsZoneViewsAddresources_580159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add resources to the view.
  ## 
  let valid = call_580173.validator(path, query, header, formData, body)
  let scheme = call_580173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580173.url(scheme.get, call_580173.host, call_580173.base,
                         call_580173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580173, url, valid)

proc call*(call_580174: Call_ResourceviewsZoneViewsAddresources_580159;
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
  var path_580175 = newJObject()
  var query_580176 = newJObject()
  var body_580177 = newJObject()
  add(path_580175, "zone", newJString(zone))
  add(query_580176, "fields", newJString(fields))
  add(query_580176, "quotaUser", newJString(quotaUser))
  add(query_580176, "alt", newJString(alt))
  add(query_580176, "oauth_token", newJString(oauthToken))
  add(path_580175, "resourceViewName", newJString(resourceViewName))
  add(query_580176, "userIp", newJString(userIp))
  add(query_580176, "key", newJString(key))
  add(path_580175, "projectName", newJString(projectName))
  if body != nil:
    body_580177 = body
  add(query_580176, "prettyPrint", newJBool(prettyPrint))
  result = call_580174.call(path_580175, query_580176, nil, nil, body_580177)

var resourceviewsZoneViewsAddresources* = Call_ResourceviewsZoneViewsAddresources_580159(
    name: "resourceviewsZoneViewsAddresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}/addResources",
    validator: validate_ResourceviewsZoneViewsAddresources_580160,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsAddresources_580161, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsRemoveresources_580178 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsRemoveresources_580180(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsZoneViewsRemoveresources_580179(path: JsonNode;
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
  var valid_580181 = path.getOrDefault("zone")
  valid_580181 = validateParameter(valid_580181, JString, required = true,
                                 default = nil)
  if valid_580181 != nil:
    section.add "zone", valid_580181
  var valid_580182 = path.getOrDefault("resourceViewName")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "resourceViewName", valid_580182
  var valid_580183 = path.getOrDefault("projectName")
  valid_580183 = validateParameter(valid_580183, JString, required = true,
                                 default = nil)
  if valid_580183 != nil:
    section.add "projectName", valid_580183
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
  var valid_580184 = query.getOrDefault("fields")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "fields", valid_580184
  var valid_580185 = query.getOrDefault("quotaUser")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "quotaUser", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("oauth_token")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "oauth_token", valid_580187
  var valid_580188 = query.getOrDefault("userIp")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "userIp", valid_580188
  var valid_580189 = query.getOrDefault("key")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "key", valid_580189
  var valid_580190 = query.getOrDefault("prettyPrint")
  valid_580190 = validateParameter(valid_580190, JBool, required = false,
                                 default = newJBool(true))
  if valid_580190 != nil:
    section.add "prettyPrint", valid_580190
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

proc call*(call_580192: Call_ResourceviewsZoneViewsRemoveresources_580178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove resources from the view.
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_ResourceviewsZoneViewsRemoveresources_580178;
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
  var path_580194 = newJObject()
  var query_580195 = newJObject()
  var body_580196 = newJObject()
  add(path_580194, "zone", newJString(zone))
  add(query_580195, "fields", newJString(fields))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(path_580194, "resourceViewName", newJString(resourceViewName))
  add(query_580195, "userIp", newJString(userIp))
  add(query_580195, "key", newJString(key))
  add(path_580194, "projectName", newJString(projectName))
  if body != nil:
    body_580196 = body
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  result = call_580193.call(path_580194, query_580195, nil, nil, body_580196)

var resourceviewsZoneViewsRemoveresources* = Call_ResourceviewsZoneViewsRemoveresources_580178(
    name: "resourceviewsZoneViewsRemoveresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}/removeResources",
    validator: validate_ResourceviewsZoneViewsRemoveresources_580179,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsRemoveresources_580180, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsListresources_580197 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsListresources_580199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_ResourceviewsZoneViewsListresources_580198(path: JsonNode;
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
  var valid_580200 = path.getOrDefault("zone")
  valid_580200 = validateParameter(valid_580200, JString, required = true,
                                 default = nil)
  if valid_580200 != nil:
    section.add "zone", valid_580200
  var valid_580201 = path.getOrDefault("resourceViewName")
  valid_580201 = validateParameter(valid_580201, JString, required = true,
                                 default = nil)
  if valid_580201 != nil:
    section.add "resourceViewName", valid_580201
  var valid_580202 = path.getOrDefault("projectName")
  valid_580202 = validateParameter(valid_580202, JString, required = true,
                                 default = nil)
  if valid_580202 != nil:
    section.add "projectName", valid_580202
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
  var valid_580203 = query.getOrDefault("fields")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "fields", valid_580203
  var valid_580204 = query.getOrDefault("pageToken")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "pageToken", valid_580204
  var valid_580205 = query.getOrDefault("quotaUser")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "quotaUser", valid_580205
  var valid_580206 = query.getOrDefault("alt")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = newJString("json"))
  if valid_580206 != nil:
    section.add "alt", valid_580206
  var valid_580207 = query.getOrDefault("oauth_token")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "oauth_token", valid_580207
  var valid_580208 = query.getOrDefault("userIp")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "userIp", valid_580208
  var valid_580209 = query.getOrDefault("maxResults")
  valid_580209 = validateParameter(valid_580209, JInt, required = false,
                                 default = newJInt(5000))
  if valid_580209 != nil:
    section.add "maxResults", valid_580209
  var valid_580210 = query.getOrDefault("key")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "key", valid_580210
  var valid_580211 = query.getOrDefault("prettyPrint")
  valid_580211 = validateParameter(valid_580211, JBool, required = false,
                                 default = newJBool(true))
  if valid_580211 != nil:
    section.add "prettyPrint", valid_580211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580212: Call_ResourceviewsZoneViewsListresources_580197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the resources of the resource view.
  ## 
  let valid = call_580212.validator(path, query, header, formData, body)
  let scheme = call_580212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580212.url(scheme.get, call_580212.host, call_580212.base,
                         call_580212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580212, url, valid)

proc call*(call_580213: Call_ResourceviewsZoneViewsListresources_580197;
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
  var path_580214 = newJObject()
  var query_580215 = newJObject()
  add(path_580214, "zone", newJString(zone))
  add(query_580215, "fields", newJString(fields))
  add(query_580215, "pageToken", newJString(pageToken))
  add(query_580215, "quotaUser", newJString(quotaUser))
  add(query_580215, "alt", newJString(alt))
  add(query_580215, "oauth_token", newJString(oauthToken))
  add(path_580214, "resourceViewName", newJString(resourceViewName))
  add(query_580215, "userIp", newJString(userIp))
  add(query_580215, "maxResults", newJInt(maxResults))
  add(query_580215, "key", newJString(key))
  add(path_580214, "projectName", newJString(projectName))
  add(query_580215, "prettyPrint", newJBool(prettyPrint))
  result = call_580213.call(path_580214, query_580215, nil, nil, nil)

var resourceviewsZoneViewsListresources* = Call_ResourceviewsZoneViewsListresources_580197(
    name: "resourceviewsZoneViewsListresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}/resources",
    validator: validate_ResourceviewsZoneViewsListresources_580198,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsListresources_580199, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
