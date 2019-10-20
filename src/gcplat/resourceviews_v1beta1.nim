
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

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "resourceviews"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ResourceviewsRegionViewsInsert_578913 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsRegionViewsInsert_578915(protocol: Scheme; host: string;
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

proc validate_ResourceviewsRegionViewsInsert_578914(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   region: JString (required)
  ##         : The region name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `region` field"
  var valid_578916 = path.getOrDefault("region")
  valid_578916 = validateParameter(valid_578916, JString, required = true,
                                 default = nil)
  if valid_578916 != nil:
    section.add "region", valid_578916
  var valid_578917 = path.getOrDefault("projectName")
  valid_578917 = validateParameter(valid_578917, JString, required = true,
                                 default = nil)
  if valid_578917 != nil:
    section.add "projectName", valid_578917
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578918 = query.getOrDefault("key")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "key", valid_578918
  var valid_578919 = query.getOrDefault("prettyPrint")
  valid_578919 = validateParameter(valid_578919, JBool, required = false,
                                 default = newJBool(true))
  if valid_578919 != nil:
    section.add "prettyPrint", valid_578919
  var valid_578920 = query.getOrDefault("oauth_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "oauth_token", valid_578920
  var valid_578921 = query.getOrDefault("alt")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = newJString("json"))
  if valid_578921 != nil:
    section.add "alt", valid_578921
  var valid_578922 = query.getOrDefault("userIp")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "userIp", valid_578922
  var valid_578923 = query.getOrDefault("quotaUser")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "quotaUser", valid_578923
  var valid_578924 = query.getOrDefault("fields")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "fields", valid_578924
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

proc call*(call_578926: Call_ResourceviewsRegionViewsInsert_578913; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource view.
  ## 
  let valid = call_578926.validator(path, query, header, formData, body)
  let scheme = call_578926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578926.url(scheme.get, call_578926.host, call_578926.base,
                         call_578926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578926, url, valid)

proc call*(call_578927: Call_ResourceviewsRegionViewsInsert_578913; region: string;
          projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## resourceviewsRegionViewsInsert
  ## Create a resource view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   body: JObject
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578928 = newJObject()
  var query_578929 = newJObject()
  var body_578930 = newJObject()
  add(query_578929, "key", newJString(key))
  add(query_578929, "prettyPrint", newJBool(prettyPrint))
  add(query_578929, "oauth_token", newJString(oauthToken))
  add(query_578929, "alt", newJString(alt))
  add(query_578929, "userIp", newJString(userIp))
  add(query_578929, "quotaUser", newJString(quotaUser))
  add(path_578928, "region", newJString(region))
  if body != nil:
    body_578930 = body
  add(path_578928, "projectName", newJString(projectName))
  add(query_578929, "fields", newJString(fields))
  result = call_578927.call(path_578928, query_578929, nil, nil, body_578930)

var resourceviewsRegionViewsInsert* = Call_ResourceviewsRegionViewsInsert_578913(
    name: "resourceviewsRegionViewsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews",
    validator: validate_ResourceviewsRegionViewsInsert_578914,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsInsert_578915, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsList_578625 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsRegionViewsList_578627(protocol: Scheme; host: string;
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

proc validate_ResourceviewsRegionViewsList_578626(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List resource views.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   region: JString (required)
  ##         : The region name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `region` field"
  var valid_578753 = path.getOrDefault("region")
  valid_578753 = validateParameter(valid_578753, JString, required = true,
                                 default = nil)
  if valid_578753 != nil:
    section.add "region", valid_578753
  var valid_578754 = path.getOrDefault("projectName")
  valid_578754 = validateParameter(valid_578754, JString, required = true,
                                 default = nil)
  if valid_578754 != nil:
    section.add "projectName", valid_578754
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  section = newJObject()
  var valid_578755 = query.getOrDefault("key")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "key", valid_578755
  var valid_578769 = query.getOrDefault("prettyPrint")
  valid_578769 = validateParameter(valid_578769, JBool, required = false,
                                 default = newJBool(true))
  if valid_578769 != nil:
    section.add "prettyPrint", valid_578769
  var valid_578770 = query.getOrDefault("oauth_token")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "oauth_token", valid_578770
  var valid_578771 = query.getOrDefault("alt")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = newJString("json"))
  if valid_578771 != nil:
    section.add "alt", valid_578771
  var valid_578772 = query.getOrDefault("userIp")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "userIp", valid_578772
  var valid_578773 = query.getOrDefault("quotaUser")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "quotaUser", valid_578773
  var valid_578774 = query.getOrDefault("pageToken")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = nil)
  if valid_578774 != nil:
    section.add "pageToken", valid_578774
  var valid_578775 = query.getOrDefault("fields")
  valid_578775 = validateParameter(valid_578775, JString, required = false,
                                 default = nil)
  if valid_578775 != nil:
    section.add "fields", valid_578775
  var valid_578777 = query.getOrDefault("maxResults")
  valid_578777 = validateParameter(valid_578777, JInt, required = false,
                                 default = newJInt(5000))
  if valid_578777 != nil:
    section.add "maxResults", valid_578777
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578800: Call_ResourceviewsRegionViewsList_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List resource views.
  ## 
  let valid = call_578800.validator(path, query, header, formData, body)
  let scheme = call_578800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578800.url(scheme.get, call_578800.host, call_578800.base,
                         call_578800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578800, url, valid)

proc call*(call_578871: Call_ResourceviewsRegionViewsList_578625; region: string;
          projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 5000): Recallable =
  ## resourceviewsRegionViewsList
  ## List resource views.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   pageToken: string
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  var path_578872 = newJObject()
  var query_578874 = newJObject()
  add(query_578874, "key", newJString(key))
  add(query_578874, "prettyPrint", newJBool(prettyPrint))
  add(query_578874, "oauth_token", newJString(oauthToken))
  add(query_578874, "alt", newJString(alt))
  add(query_578874, "userIp", newJString(userIp))
  add(query_578874, "quotaUser", newJString(quotaUser))
  add(path_578872, "region", newJString(region))
  add(query_578874, "pageToken", newJString(pageToken))
  add(path_578872, "projectName", newJString(projectName))
  add(query_578874, "fields", newJString(fields))
  add(query_578874, "maxResults", newJInt(maxResults))
  result = call_578871.call(path_578872, query_578874, nil, nil, nil)

var resourceviewsRegionViewsList* = Call_ResourceviewsRegionViewsList_578625(
    name: "resourceviewsRegionViewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews",
    validator: validate_ResourceviewsRegionViewsList_578626,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsList_578627, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsGet_578931 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsRegionViewsGet_578933(protocol: Scheme; host: string;
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

proc validate_ResourceviewsRegionViewsGet_578932(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the information of a resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   region: JString (required)
  ##         : The region name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_578934 = path.getOrDefault("resourceViewName")
  valid_578934 = validateParameter(valid_578934, JString, required = true,
                                 default = nil)
  if valid_578934 != nil:
    section.add "resourceViewName", valid_578934
  var valid_578935 = path.getOrDefault("region")
  valid_578935 = validateParameter(valid_578935, JString, required = true,
                                 default = nil)
  if valid_578935 != nil:
    section.add "region", valid_578935
  var valid_578936 = path.getOrDefault("projectName")
  valid_578936 = validateParameter(valid_578936, JString, required = true,
                                 default = nil)
  if valid_578936 != nil:
    section.add "projectName", valid_578936
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578937 = query.getOrDefault("key")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "key", valid_578937
  var valid_578938 = query.getOrDefault("prettyPrint")
  valid_578938 = validateParameter(valid_578938, JBool, required = false,
                                 default = newJBool(true))
  if valid_578938 != nil:
    section.add "prettyPrint", valid_578938
  var valid_578939 = query.getOrDefault("oauth_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "oauth_token", valid_578939
  var valid_578940 = query.getOrDefault("alt")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = newJString("json"))
  if valid_578940 != nil:
    section.add "alt", valid_578940
  var valid_578941 = query.getOrDefault("userIp")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "userIp", valid_578941
  var valid_578942 = query.getOrDefault("quotaUser")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "quotaUser", valid_578942
  var valid_578943 = query.getOrDefault("fields")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "fields", valid_578943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578944: Call_ResourceviewsRegionViewsGet_578931; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information of a resource view.
  ## 
  let valid = call_578944.validator(path, query, header, formData, body)
  let scheme = call_578944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578944.url(scheme.get, call_578944.host, call_578944.base,
                         call_578944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578944, url, valid)

proc call*(call_578945: Call_ResourceviewsRegionViewsGet_578931;
          resourceViewName: string; region: string; projectName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## resourceviewsRegionViewsGet
  ## Get the information of a resource view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578946 = newJObject()
  var query_578947 = newJObject()
  add(query_578947, "key", newJString(key))
  add(query_578947, "prettyPrint", newJBool(prettyPrint))
  add(query_578947, "oauth_token", newJString(oauthToken))
  add(path_578946, "resourceViewName", newJString(resourceViewName))
  add(query_578947, "alt", newJString(alt))
  add(query_578947, "userIp", newJString(userIp))
  add(query_578947, "quotaUser", newJString(quotaUser))
  add(path_578946, "region", newJString(region))
  add(path_578946, "projectName", newJString(projectName))
  add(query_578947, "fields", newJString(fields))
  result = call_578945.call(path_578946, query_578947, nil, nil, nil)

var resourceviewsRegionViewsGet* = Call_ResourceviewsRegionViewsGet_578931(
    name: "resourceviewsRegionViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsRegionViewsGet_578932,
    base: "/resourceviews/v1beta1/projects", url: url_ResourceviewsRegionViewsGet_578933,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsDelete_578948 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsRegionViewsDelete_578950(protocol: Scheme; host: string;
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

proc validate_ResourceviewsRegionViewsDelete_578949(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   region: JString (required)
  ##         : The region name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_578951 = path.getOrDefault("resourceViewName")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "resourceViewName", valid_578951
  var valid_578952 = path.getOrDefault("region")
  valid_578952 = validateParameter(valid_578952, JString, required = true,
                                 default = nil)
  if valid_578952 != nil:
    section.add "region", valid_578952
  var valid_578953 = path.getOrDefault("projectName")
  valid_578953 = validateParameter(valid_578953, JString, required = true,
                                 default = nil)
  if valid_578953 != nil:
    section.add "projectName", valid_578953
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578954 = query.getOrDefault("key")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "key", valid_578954
  var valid_578955 = query.getOrDefault("prettyPrint")
  valid_578955 = validateParameter(valid_578955, JBool, required = false,
                                 default = newJBool(true))
  if valid_578955 != nil:
    section.add "prettyPrint", valid_578955
  var valid_578956 = query.getOrDefault("oauth_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "oauth_token", valid_578956
  var valid_578957 = query.getOrDefault("alt")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("json"))
  if valid_578957 != nil:
    section.add "alt", valid_578957
  var valid_578958 = query.getOrDefault("userIp")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "userIp", valid_578958
  var valid_578959 = query.getOrDefault("quotaUser")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "quotaUser", valid_578959
  var valid_578960 = query.getOrDefault("fields")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "fields", valid_578960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578961: Call_ResourceviewsRegionViewsDelete_578948; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a resource view.
  ## 
  let valid = call_578961.validator(path, query, header, formData, body)
  let scheme = call_578961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578961.url(scheme.get, call_578961.host, call_578961.base,
                         call_578961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578961, url, valid)

proc call*(call_578962: Call_ResourceviewsRegionViewsDelete_578948;
          resourceViewName: string; region: string; projectName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## resourceviewsRegionViewsDelete
  ## Delete a resource view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578963 = newJObject()
  var query_578964 = newJObject()
  add(query_578964, "key", newJString(key))
  add(query_578964, "prettyPrint", newJBool(prettyPrint))
  add(query_578964, "oauth_token", newJString(oauthToken))
  add(path_578963, "resourceViewName", newJString(resourceViewName))
  add(query_578964, "alt", newJString(alt))
  add(query_578964, "userIp", newJString(userIp))
  add(query_578964, "quotaUser", newJString(quotaUser))
  add(path_578963, "region", newJString(region))
  add(path_578963, "projectName", newJString(projectName))
  add(query_578964, "fields", newJString(fields))
  result = call_578962.call(path_578963, query_578964, nil, nil, nil)

var resourceviewsRegionViewsDelete* = Call_ResourceviewsRegionViewsDelete_578948(
    name: "resourceviewsRegionViewsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsRegionViewsDelete_578949,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsDelete_578950, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsAddresources_578965 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsRegionViewsAddresources_578967(protocol: Scheme;
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

proc validate_ResourceviewsRegionViewsAddresources_578966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add resources to the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   region: JString (required)
  ##         : The region name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_578968 = path.getOrDefault("resourceViewName")
  valid_578968 = validateParameter(valid_578968, JString, required = true,
                                 default = nil)
  if valid_578968 != nil:
    section.add "resourceViewName", valid_578968
  var valid_578969 = path.getOrDefault("region")
  valid_578969 = validateParameter(valid_578969, JString, required = true,
                                 default = nil)
  if valid_578969 != nil:
    section.add "region", valid_578969
  var valid_578970 = path.getOrDefault("projectName")
  valid_578970 = validateParameter(valid_578970, JString, required = true,
                                 default = nil)
  if valid_578970 != nil:
    section.add "projectName", valid_578970
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578971 = query.getOrDefault("key")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "key", valid_578971
  var valid_578972 = query.getOrDefault("prettyPrint")
  valid_578972 = validateParameter(valid_578972, JBool, required = false,
                                 default = newJBool(true))
  if valid_578972 != nil:
    section.add "prettyPrint", valid_578972
  var valid_578973 = query.getOrDefault("oauth_token")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "oauth_token", valid_578973
  var valid_578974 = query.getOrDefault("alt")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = newJString("json"))
  if valid_578974 != nil:
    section.add "alt", valid_578974
  var valid_578975 = query.getOrDefault("userIp")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "userIp", valid_578975
  var valid_578976 = query.getOrDefault("quotaUser")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "quotaUser", valid_578976
  var valid_578977 = query.getOrDefault("fields")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "fields", valid_578977
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

proc call*(call_578979: Call_ResourceviewsRegionViewsAddresources_578965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add resources to the view.
  ## 
  let valid = call_578979.validator(path, query, header, formData, body)
  let scheme = call_578979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578979.url(scheme.get, call_578979.host, call_578979.base,
                         call_578979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578979, url, valid)

proc call*(call_578980: Call_ResourceviewsRegionViewsAddresources_578965;
          resourceViewName: string; region: string; projectName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## resourceviewsRegionViewsAddresources
  ## Add resources to the view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   body: JObject
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578981 = newJObject()
  var query_578982 = newJObject()
  var body_578983 = newJObject()
  add(query_578982, "key", newJString(key))
  add(query_578982, "prettyPrint", newJBool(prettyPrint))
  add(query_578982, "oauth_token", newJString(oauthToken))
  add(path_578981, "resourceViewName", newJString(resourceViewName))
  add(query_578982, "alt", newJString(alt))
  add(query_578982, "userIp", newJString(userIp))
  add(query_578982, "quotaUser", newJString(quotaUser))
  add(path_578981, "region", newJString(region))
  if body != nil:
    body_578983 = body
  add(path_578981, "projectName", newJString(projectName))
  add(query_578982, "fields", newJString(fields))
  result = call_578980.call(path_578981, query_578982, nil, nil, body_578983)

var resourceviewsRegionViewsAddresources* = Call_ResourceviewsRegionViewsAddresources_578965(
    name: "resourceviewsRegionViewsAddresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}/addResources",
    validator: validate_ResourceviewsRegionViewsAddresources_578966,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsAddresources_578967, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsRemoveresources_578984 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsRegionViewsRemoveresources_578986(protocol: Scheme;
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

proc validate_ResourceviewsRegionViewsRemoveresources_578985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove resources from the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   region: JString (required)
  ##         : The region name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_578987 = path.getOrDefault("resourceViewName")
  valid_578987 = validateParameter(valid_578987, JString, required = true,
                                 default = nil)
  if valid_578987 != nil:
    section.add "resourceViewName", valid_578987
  var valid_578988 = path.getOrDefault("region")
  valid_578988 = validateParameter(valid_578988, JString, required = true,
                                 default = nil)
  if valid_578988 != nil:
    section.add "region", valid_578988
  var valid_578989 = path.getOrDefault("projectName")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "projectName", valid_578989
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578990 = query.getOrDefault("key")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "key", valid_578990
  var valid_578991 = query.getOrDefault("prettyPrint")
  valid_578991 = validateParameter(valid_578991, JBool, required = false,
                                 default = newJBool(true))
  if valid_578991 != nil:
    section.add "prettyPrint", valid_578991
  var valid_578992 = query.getOrDefault("oauth_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "oauth_token", valid_578992
  var valid_578993 = query.getOrDefault("alt")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("json"))
  if valid_578993 != nil:
    section.add "alt", valid_578993
  var valid_578994 = query.getOrDefault("userIp")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "userIp", valid_578994
  var valid_578995 = query.getOrDefault("quotaUser")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "quotaUser", valid_578995
  var valid_578996 = query.getOrDefault("fields")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "fields", valid_578996
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

proc call*(call_578998: Call_ResourceviewsRegionViewsRemoveresources_578984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove resources from the view.
  ## 
  let valid = call_578998.validator(path, query, header, formData, body)
  let scheme = call_578998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578998.url(scheme.get, call_578998.host, call_578998.base,
                         call_578998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578998, url, valid)

proc call*(call_578999: Call_ResourceviewsRegionViewsRemoveresources_578984;
          resourceViewName: string; region: string; projectName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## resourceviewsRegionViewsRemoveresources
  ## Remove resources from the view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   body: JObject
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579000 = newJObject()
  var query_579001 = newJObject()
  var body_579002 = newJObject()
  add(query_579001, "key", newJString(key))
  add(query_579001, "prettyPrint", newJBool(prettyPrint))
  add(query_579001, "oauth_token", newJString(oauthToken))
  add(path_579000, "resourceViewName", newJString(resourceViewName))
  add(query_579001, "alt", newJString(alt))
  add(query_579001, "userIp", newJString(userIp))
  add(query_579001, "quotaUser", newJString(quotaUser))
  add(path_579000, "region", newJString(region))
  if body != nil:
    body_579002 = body
  add(path_579000, "projectName", newJString(projectName))
  add(query_579001, "fields", newJString(fields))
  result = call_578999.call(path_579000, query_579001, nil, nil, body_579002)

var resourceviewsRegionViewsRemoveresources* = Call_ResourceviewsRegionViewsRemoveresources_578984(
    name: "resourceviewsRegionViewsRemoveresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}/removeResources",
    validator: validate_ResourceviewsRegionViewsRemoveresources_578985,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsRemoveresources_578986,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsListresources_579003 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsRegionViewsListresources_579005(protocol: Scheme;
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

proc validate_ResourceviewsRegionViewsListresources_579004(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the resources in the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   region: JString (required)
  ##         : The region name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_579006 = path.getOrDefault("resourceViewName")
  valid_579006 = validateParameter(valid_579006, JString, required = true,
                                 default = nil)
  if valid_579006 != nil:
    section.add "resourceViewName", valid_579006
  var valid_579007 = path.getOrDefault("region")
  valid_579007 = validateParameter(valid_579007, JString, required = true,
                                 default = nil)
  if valid_579007 != nil:
    section.add "region", valid_579007
  var valid_579008 = path.getOrDefault("projectName")
  valid_579008 = validateParameter(valid_579008, JString, required = true,
                                 default = nil)
  if valid_579008 != nil:
    section.add "projectName", valid_579008
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  section = newJObject()
  var valid_579009 = query.getOrDefault("key")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "key", valid_579009
  var valid_579010 = query.getOrDefault("prettyPrint")
  valid_579010 = validateParameter(valid_579010, JBool, required = false,
                                 default = newJBool(true))
  if valid_579010 != nil:
    section.add "prettyPrint", valid_579010
  var valid_579011 = query.getOrDefault("oauth_token")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "oauth_token", valid_579011
  var valid_579012 = query.getOrDefault("alt")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = newJString("json"))
  if valid_579012 != nil:
    section.add "alt", valid_579012
  var valid_579013 = query.getOrDefault("userIp")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "userIp", valid_579013
  var valid_579014 = query.getOrDefault("quotaUser")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "quotaUser", valid_579014
  var valid_579015 = query.getOrDefault("pageToken")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "pageToken", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
  var valid_579017 = query.getOrDefault("maxResults")
  valid_579017 = validateParameter(valid_579017, JInt, required = false,
                                 default = newJInt(5000))
  if valid_579017 != nil:
    section.add "maxResults", valid_579017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579018: Call_ResourceviewsRegionViewsListresources_579003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the resources in the view.
  ## 
  let valid = call_579018.validator(path, query, header, formData, body)
  let scheme = call_579018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579018.url(scheme.get, call_579018.host, call_579018.base,
                         call_579018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579018, url, valid)

proc call*(call_579019: Call_ResourceviewsRegionViewsListresources_579003;
          resourceViewName: string; region: string; projectName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 5000): Recallable =
  ## resourceviewsRegionViewsListresources
  ## List the resources in the view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   region: string (required)
  ##         : The region name of the resource view.
  ##   pageToken: string
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  var path_579020 = newJObject()
  var query_579021 = newJObject()
  add(query_579021, "key", newJString(key))
  add(query_579021, "prettyPrint", newJBool(prettyPrint))
  add(query_579021, "oauth_token", newJString(oauthToken))
  add(path_579020, "resourceViewName", newJString(resourceViewName))
  add(query_579021, "alt", newJString(alt))
  add(query_579021, "userIp", newJString(userIp))
  add(query_579021, "quotaUser", newJString(quotaUser))
  add(path_579020, "region", newJString(region))
  add(query_579021, "pageToken", newJString(pageToken))
  add(path_579020, "projectName", newJString(projectName))
  add(query_579021, "fields", newJString(fields))
  add(query_579021, "maxResults", newJInt(maxResults))
  result = call_579019.call(path_579020, query_579021, nil, nil, nil)

var resourceviewsRegionViewsListresources* = Call_ResourceviewsRegionViewsListresources_579003(
    name: "resourceviewsRegionViewsListresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}/resources",
    validator: validate_ResourceviewsRegionViewsListresources_579004,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsListresources_579005, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsInsert_579040 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsZoneViewsInsert_579042(protocol: Scheme; host: string;
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

proc validate_ResourceviewsZoneViewsInsert_579041(path: JsonNode; query: JsonNode;
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
  var valid_579043 = path.getOrDefault("zone")
  valid_579043 = validateParameter(valid_579043, JString, required = true,
                                 default = nil)
  if valid_579043 != nil:
    section.add "zone", valid_579043
  var valid_579044 = path.getOrDefault("projectName")
  valid_579044 = validateParameter(valid_579044, JString, required = true,
                                 default = nil)
  if valid_579044 != nil:
    section.add "projectName", valid_579044
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579045 = query.getOrDefault("key")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "key", valid_579045
  var valid_579046 = query.getOrDefault("prettyPrint")
  valid_579046 = validateParameter(valid_579046, JBool, required = false,
                                 default = newJBool(true))
  if valid_579046 != nil:
    section.add "prettyPrint", valid_579046
  var valid_579047 = query.getOrDefault("oauth_token")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "oauth_token", valid_579047
  var valid_579048 = query.getOrDefault("alt")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = newJString("json"))
  if valid_579048 != nil:
    section.add "alt", valid_579048
  var valid_579049 = query.getOrDefault("userIp")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "userIp", valid_579049
  var valid_579050 = query.getOrDefault("quotaUser")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "quotaUser", valid_579050
  var valid_579051 = query.getOrDefault("fields")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "fields", valid_579051
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

proc call*(call_579053: Call_ResourceviewsZoneViewsInsert_579040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource view.
  ## 
  let valid = call_579053.validator(path, query, header, formData, body)
  let scheme = call_579053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579053.url(scheme.get, call_579053.host, call_579053.base,
                         call_579053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579053, url, valid)

proc call*(call_579054: Call_ResourceviewsZoneViewsInsert_579040; zone: string;
          projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## resourceviewsZoneViewsInsert
  ## Create a resource view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   body: JObject
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579055 = newJObject()
  var query_579056 = newJObject()
  var body_579057 = newJObject()
  add(query_579056, "key", newJString(key))
  add(query_579056, "prettyPrint", newJBool(prettyPrint))
  add(query_579056, "oauth_token", newJString(oauthToken))
  add(query_579056, "alt", newJString(alt))
  add(query_579056, "userIp", newJString(userIp))
  add(query_579056, "quotaUser", newJString(quotaUser))
  add(path_579055, "zone", newJString(zone))
  if body != nil:
    body_579057 = body
  add(path_579055, "projectName", newJString(projectName))
  add(query_579056, "fields", newJString(fields))
  result = call_579054.call(path_579055, query_579056, nil, nil, body_579057)

var resourceviewsZoneViewsInsert* = Call_ResourceviewsZoneViewsInsert_579040(
    name: "resourceviewsZoneViewsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews",
    validator: validate_ResourceviewsZoneViewsInsert_579041,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsInsert_579042, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsList_579022 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsZoneViewsList_579024(protocol: Scheme; host: string;
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

proc validate_ResourceviewsZoneViewsList_579023(path: JsonNode; query: JsonNode;
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
  var valid_579025 = path.getOrDefault("zone")
  valid_579025 = validateParameter(valid_579025, JString, required = true,
                                 default = nil)
  if valid_579025 != nil:
    section.add "zone", valid_579025
  var valid_579026 = path.getOrDefault("projectName")
  valid_579026 = validateParameter(valid_579026, JString, required = true,
                                 default = nil)
  if valid_579026 != nil:
    section.add "projectName", valid_579026
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  section = newJObject()
  var valid_579027 = query.getOrDefault("key")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "key", valid_579027
  var valid_579028 = query.getOrDefault("prettyPrint")
  valid_579028 = validateParameter(valid_579028, JBool, required = false,
                                 default = newJBool(true))
  if valid_579028 != nil:
    section.add "prettyPrint", valid_579028
  var valid_579029 = query.getOrDefault("oauth_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "oauth_token", valid_579029
  var valid_579030 = query.getOrDefault("alt")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = newJString("json"))
  if valid_579030 != nil:
    section.add "alt", valid_579030
  var valid_579031 = query.getOrDefault("userIp")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "userIp", valid_579031
  var valid_579032 = query.getOrDefault("quotaUser")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "quotaUser", valid_579032
  var valid_579033 = query.getOrDefault("pageToken")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "pageToken", valid_579033
  var valid_579034 = query.getOrDefault("fields")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "fields", valid_579034
  var valid_579035 = query.getOrDefault("maxResults")
  valid_579035 = validateParameter(valid_579035, JInt, required = false,
                                 default = newJInt(5000))
  if valid_579035 != nil:
    section.add "maxResults", valid_579035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579036: Call_ResourceviewsZoneViewsList_579022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List resource views.
  ## 
  let valid = call_579036.validator(path, query, header, formData, body)
  let scheme = call_579036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579036.url(scheme.get, call_579036.host, call_579036.base,
                         call_579036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579036, url, valid)

proc call*(call_579037: Call_ResourceviewsZoneViewsList_579022; zone: string;
          projectName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 5000): Recallable =
  ## resourceviewsZoneViewsList
  ## List resource views.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  var path_579038 = newJObject()
  var query_579039 = newJObject()
  add(query_579039, "key", newJString(key))
  add(query_579039, "prettyPrint", newJBool(prettyPrint))
  add(query_579039, "oauth_token", newJString(oauthToken))
  add(query_579039, "alt", newJString(alt))
  add(query_579039, "userIp", newJString(userIp))
  add(query_579039, "quotaUser", newJString(quotaUser))
  add(query_579039, "pageToken", newJString(pageToken))
  add(path_579038, "zone", newJString(zone))
  add(path_579038, "projectName", newJString(projectName))
  add(query_579039, "fields", newJString(fields))
  add(query_579039, "maxResults", newJInt(maxResults))
  result = call_579037.call(path_579038, query_579039, nil, nil, nil)

var resourceviewsZoneViewsList* = Call_ResourceviewsZoneViewsList_579022(
    name: "resourceviewsZoneViewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews",
    validator: validate_ResourceviewsZoneViewsList_579023,
    base: "/resourceviews/v1beta1/projects", url: url_ResourceviewsZoneViewsList_579024,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsGet_579058 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsZoneViewsGet_579060(protocol: Scheme; host: string;
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

proc validate_ResourceviewsZoneViewsGet_579059(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the information of a zonal resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_579061 = path.getOrDefault("resourceViewName")
  valid_579061 = validateParameter(valid_579061, JString, required = true,
                                 default = nil)
  if valid_579061 != nil:
    section.add "resourceViewName", valid_579061
  var valid_579062 = path.getOrDefault("zone")
  valid_579062 = validateParameter(valid_579062, JString, required = true,
                                 default = nil)
  if valid_579062 != nil:
    section.add "zone", valid_579062
  var valid_579063 = path.getOrDefault("projectName")
  valid_579063 = validateParameter(valid_579063, JString, required = true,
                                 default = nil)
  if valid_579063 != nil:
    section.add "projectName", valid_579063
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579064 = query.getOrDefault("key")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "key", valid_579064
  var valid_579065 = query.getOrDefault("prettyPrint")
  valid_579065 = validateParameter(valid_579065, JBool, required = false,
                                 default = newJBool(true))
  if valid_579065 != nil:
    section.add "prettyPrint", valid_579065
  var valid_579066 = query.getOrDefault("oauth_token")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "oauth_token", valid_579066
  var valid_579067 = query.getOrDefault("alt")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = newJString("json"))
  if valid_579067 != nil:
    section.add "alt", valid_579067
  var valid_579068 = query.getOrDefault("userIp")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "userIp", valid_579068
  var valid_579069 = query.getOrDefault("quotaUser")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "quotaUser", valid_579069
  var valid_579070 = query.getOrDefault("fields")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "fields", valid_579070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579071: Call_ResourceviewsZoneViewsGet_579058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information of a zonal resource view.
  ## 
  let valid = call_579071.validator(path, query, header, formData, body)
  let scheme = call_579071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579071.url(scheme.get, call_579071.host, call_579071.base,
                         call_579071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579071, url, valid)

proc call*(call_579072: Call_ResourceviewsZoneViewsGet_579058;
          resourceViewName: string; zone: string; projectName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## resourceviewsZoneViewsGet
  ## Get the information of a zonal resource view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579073 = newJObject()
  var query_579074 = newJObject()
  add(query_579074, "key", newJString(key))
  add(query_579074, "prettyPrint", newJBool(prettyPrint))
  add(query_579074, "oauth_token", newJString(oauthToken))
  add(path_579073, "resourceViewName", newJString(resourceViewName))
  add(query_579074, "alt", newJString(alt))
  add(query_579074, "userIp", newJString(userIp))
  add(query_579074, "quotaUser", newJString(quotaUser))
  add(path_579073, "zone", newJString(zone))
  add(path_579073, "projectName", newJString(projectName))
  add(query_579074, "fields", newJString(fields))
  result = call_579072.call(path_579073, query_579074, nil, nil, nil)

var resourceviewsZoneViewsGet* = Call_ResourceviewsZoneViewsGet_579058(
    name: "resourceviewsZoneViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsZoneViewsGet_579059,
    base: "/resourceviews/v1beta1/projects", url: url_ResourceviewsZoneViewsGet_579060,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsDelete_579075 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsZoneViewsDelete_579077(protocol: Scheme; host: string;
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

proc validate_ResourceviewsZoneViewsDelete_579076(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_579078 = path.getOrDefault("resourceViewName")
  valid_579078 = validateParameter(valid_579078, JString, required = true,
                                 default = nil)
  if valid_579078 != nil:
    section.add "resourceViewName", valid_579078
  var valid_579079 = path.getOrDefault("zone")
  valid_579079 = validateParameter(valid_579079, JString, required = true,
                                 default = nil)
  if valid_579079 != nil:
    section.add "zone", valid_579079
  var valid_579080 = path.getOrDefault("projectName")
  valid_579080 = validateParameter(valid_579080, JString, required = true,
                                 default = nil)
  if valid_579080 != nil:
    section.add "projectName", valid_579080
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579081 = query.getOrDefault("key")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "key", valid_579081
  var valid_579082 = query.getOrDefault("prettyPrint")
  valid_579082 = validateParameter(valid_579082, JBool, required = false,
                                 default = newJBool(true))
  if valid_579082 != nil:
    section.add "prettyPrint", valid_579082
  var valid_579083 = query.getOrDefault("oauth_token")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "oauth_token", valid_579083
  var valid_579084 = query.getOrDefault("alt")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = newJString("json"))
  if valid_579084 != nil:
    section.add "alt", valid_579084
  var valid_579085 = query.getOrDefault("userIp")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "userIp", valid_579085
  var valid_579086 = query.getOrDefault("quotaUser")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "quotaUser", valid_579086
  var valid_579087 = query.getOrDefault("fields")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "fields", valid_579087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579088: Call_ResourceviewsZoneViewsDelete_579075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a resource view.
  ## 
  let valid = call_579088.validator(path, query, header, formData, body)
  let scheme = call_579088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579088.url(scheme.get, call_579088.host, call_579088.base,
                         call_579088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579088, url, valid)

proc call*(call_579089: Call_ResourceviewsZoneViewsDelete_579075;
          resourceViewName: string; zone: string; projectName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## resourceviewsZoneViewsDelete
  ## Delete a resource view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579090 = newJObject()
  var query_579091 = newJObject()
  add(query_579091, "key", newJString(key))
  add(query_579091, "prettyPrint", newJBool(prettyPrint))
  add(query_579091, "oauth_token", newJString(oauthToken))
  add(path_579090, "resourceViewName", newJString(resourceViewName))
  add(query_579091, "alt", newJString(alt))
  add(query_579091, "userIp", newJString(userIp))
  add(query_579091, "quotaUser", newJString(quotaUser))
  add(path_579090, "zone", newJString(zone))
  add(path_579090, "projectName", newJString(projectName))
  add(query_579091, "fields", newJString(fields))
  result = call_579089.call(path_579090, query_579091, nil, nil, nil)

var resourceviewsZoneViewsDelete* = Call_ResourceviewsZoneViewsDelete_579075(
    name: "resourceviewsZoneViewsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsZoneViewsDelete_579076,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsDelete_579077, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsAddresources_579092 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsZoneViewsAddresources_579094(protocol: Scheme; host: string;
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

proc validate_ResourceviewsZoneViewsAddresources_579093(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add resources to the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_579095 = path.getOrDefault("resourceViewName")
  valid_579095 = validateParameter(valid_579095, JString, required = true,
                                 default = nil)
  if valid_579095 != nil:
    section.add "resourceViewName", valid_579095
  var valid_579096 = path.getOrDefault("zone")
  valid_579096 = validateParameter(valid_579096, JString, required = true,
                                 default = nil)
  if valid_579096 != nil:
    section.add "zone", valid_579096
  var valid_579097 = path.getOrDefault("projectName")
  valid_579097 = validateParameter(valid_579097, JString, required = true,
                                 default = nil)
  if valid_579097 != nil:
    section.add "projectName", valid_579097
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579098 = query.getOrDefault("key")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "key", valid_579098
  var valid_579099 = query.getOrDefault("prettyPrint")
  valid_579099 = validateParameter(valid_579099, JBool, required = false,
                                 default = newJBool(true))
  if valid_579099 != nil:
    section.add "prettyPrint", valid_579099
  var valid_579100 = query.getOrDefault("oauth_token")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "oauth_token", valid_579100
  var valid_579101 = query.getOrDefault("alt")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = newJString("json"))
  if valid_579101 != nil:
    section.add "alt", valid_579101
  var valid_579102 = query.getOrDefault("userIp")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "userIp", valid_579102
  var valid_579103 = query.getOrDefault("quotaUser")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "quotaUser", valid_579103
  var valid_579104 = query.getOrDefault("fields")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "fields", valid_579104
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

proc call*(call_579106: Call_ResourceviewsZoneViewsAddresources_579092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add resources to the view.
  ## 
  let valid = call_579106.validator(path, query, header, formData, body)
  let scheme = call_579106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579106.url(scheme.get, call_579106.host, call_579106.base,
                         call_579106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579106, url, valid)

proc call*(call_579107: Call_ResourceviewsZoneViewsAddresources_579092;
          resourceViewName: string; zone: string; projectName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## resourceviewsZoneViewsAddresources
  ## Add resources to the view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   body: JObject
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579108 = newJObject()
  var query_579109 = newJObject()
  var body_579110 = newJObject()
  add(query_579109, "key", newJString(key))
  add(query_579109, "prettyPrint", newJBool(prettyPrint))
  add(query_579109, "oauth_token", newJString(oauthToken))
  add(path_579108, "resourceViewName", newJString(resourceViewName))
  add(query_579109, "alt", newJString(alt))
  add(query_579109, "userIp", newJString(userIp))
  add(query_579109, "quotaUser", newJString(quotaUser))
  add(path_579108, "zone", newJString(zone))
  if body != nil:
    body_579110 = body
  add(path_579108, "projectName", newJString(projectName))
  add(query_579109, "fields", newJString(fields))
  result = call_579107.call(path_579108, query_579109, nil, nil, body_579110)

var resourceviewsZoneViewsAddresources* = Call_ResourceviewsZoneViewsAddresources_579092(
    name: "resourceviewsZoneViewsAddresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}/addResources",
    validator: validate_ResourceviewsZoneViewsAddresources_579093,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsAddresources_579094, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsRemoveresources_579111 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsZoneViewsRemoveresources_579113(protocol: Scheme;
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

proc validate_ResourceviewsZoneViewsRemoveresources_579112(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove resources from the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_579114 = path.getOrDefault("resourceViewName")
  valid_579114 = validateParameter(valid_579114, JString, required = true,
                                 default = nil)
  if valid_579114 != nil:
    section.add "resourceViewName", valid_579114
  var valid_579115 = path.getOrDefault("zone")
  valid_579115 = validateParameter(valid_579115, JString, required = true,
                                 default = nil)
  if valid_579115 != nil:
    section.add "zone", valid_579115
  var valid_579116 = path.getOrDefault("projectName")
  valid_579116 = validateParameter(valid_579116, JString, required = true,
                                 default = nil)
  if valid_579116 != nil:
    section.add "projectName", valid_579116
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579117 = query.getOrDefault("key")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "key", valid_579117
  var valid_579118 = query.getOrDefault("prettyPrint")
  valid_579118 = validateParameter(valid_579118, JBool, required = false,
                                 default = newJBool(true))
  if valid_579118 != nil:
    section.add "prettyPrint", valid_579118
  var valid_579119 = query.getOrDefault("oauth_token")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "oauth_token", valid_579119
  var valid_579120 = query.getOrDefault("alt")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = newJString("json"))
  if valid_579120 != nil:
    section.add "alt", valid_579120
  var valid_579121 = query.getOrDefault("userIp")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "userIp", valid_579121
  var valid_579122 = query.getOrDefault("quotaUser")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "quotaUser", valid_579122
  var valid_579123 = query.getOrDefault("fields")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "fields", valid_579123
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

proc call*(call_579125: Call_ResourceviewsZoneViewsRemoveresources_579111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove resources from the view.
  ## 
  let valid = call_579125.validator(path, query, header, formData, body)
  let scheme = call_579125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579125.url(scheme.get, call_579125.host, call_579125.base,
                         call_579125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579125, url, valid)

proc call*(call_579126: Call_ResourceviewsZoneViewsRemoveresources_579111;
          resourceViewName: string; zone: string; projectName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## resourceviewsZoneViewsRemoveresources
  ## Remove resources from the view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   body: JObject
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579127 = newJObject()
  var query_579128 = newJObject()
  var body_579129 = newJObject()
  add(query_579128, "key", newJString(key))
  add(query_579128, "prettyPrint", newJBool(prettyPrint))
  add(query_579128, "oauth_token", newJString(oauthToken))
  add(path_579127, "resourceViewName", newJString(resourceViewName))
  add(query_579128, "alt", newJString(alt))
  add(query_579128, "userIp", newJString(userIp))
  add(query_579128, "quotaUser", newJString(quotaUser))
  add(path_579127, "zone", newJString(zone))
  if body != nil:
    body_579129 = body
  add(path_579127, "projectName", newJString(projectName))
  add(query_579128, "fields", newJString(fields))
  result = call_579126.call(path_579127, query_579128, nil, nil, body_579129)

var resourceviewsZoneViewsRemoveresources* = Call_ResourceviewsZoneViewsRemoveresources_579111(
    name: "resourceviewsZoneViewsRemoveresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}/removeResources",
    validator: validate_ResourceviewsZoneViewsRemoveresources_579112,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsRemoveresources_579113, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsListresources_579130 = ref object of OpenApiRestCall_578355
proc url_ResourceviewsZoneViewsListresources_579132(protocol: Scheme; host: string;
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

proc validate_ResourceviewsZoneViewsListresources_579131(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the resources of the resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceViewName: JString (required)
  ##                   : The name of the resource view.
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   projectName: JString (required)
  ##              : The project name of the resource view.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceViewName` field"
  var valid_579133 = path.getOrDefault("resourceViewName")
  valid_579133 = validateParameter(valid_579133, JString, required = true,
                                 default = nil)
  if valid_579133 != nil:
    section.add "resourceViewName", valid_579133
  var valid_579134 = path.getOrDefault("zone")
  valid_579134 = validateParameter(valid_579134, JString, required = true,
                                 default = nil)
  if valid_579134 != nil:
    section.add "zone", valid_579134
  var valid_579135 = path.getOrDefault("projectName")
  valid_579135 = validateParameter(valid_579135, JString, required = true,
                                 default = nil)
  if valid_579135 != nil:
    section.add "projectName", valid_579135
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  section = newJObject()
  var valid_579136 = query.getOrDefault("key")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "key", valid_579136
  var valid_579137 = query.getOrDefault("prettyPrint")
  valid_579137 = validateParameter(valid_579137, JBool, required = false,
                                 default = newJBool(true))
  if valid_579137 != nil:
    section.add "prettyPrint", valid_579137
  var valid_579138 = query.getOrDefault("oauth_token")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "oauth_token", valid_579138
  var valid_579139 = query.getOrDefault("alt")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = newJString("json"))
  if valid_579139 != nil:
    section.add "alt", valid_579139
  var valid_579140 = query.getOrDefault("userIp")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "userIp", valid_579140
  var valid_579141 = query.getOrDefault("quotaUser")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "quotaUser", valid_579141
  var valid_579142 = query.getOrDefault("pageToken")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "pageToken", valid_579142
  var valid_579143 = query.getOrDefault("fields")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "fields", valid_579143
  var valid_579144 = query.getOrDefault("maxResults")
  valid_579144 = validateParameter(valid_579144, JInt, required = false,
                                 default = newJInt(5000))
  if valid_579144 != nil:
    section.add "maxResults", valid_579144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579145: Call_ResourceviewsZoneViewsListresources_579130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the resources of the resource view.
  ## 
  let valid = call_579145.validator(path, query, header, formData, body)
  let scheme = call_579145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579145.url(scheme.get, call_579145.host, call_579145.base,
                         call_579145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579145, url, valid)

proc call*(call_579146: Call_ResourceviewsZoneViewsListresources_579130;
          resourceViewName: string; zone: string; projectName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 5000): Recallable =
  ## resourceviewsZoneViewsListresources
  ## List the resources of the resource view.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   resourceViewName: string (required)
  ##                   : The name of the resource view.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   projectName: string (required)
  ##              : The project name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  var path_579147 = newJObject()
  var query_579148 = newJObject()
  add(query_579148, "key", newJString(key))
  add(query_579148, "prettyPrint", newJBool(prettyPrint))
  add(query_579148, "oauth_token", newJString(oauthToken))
  add(path_579147, "resourceViewName", newJString(resourceViewName))
  add(query_579148, "alt", newJString(alt))
  add(query_579148, "userIp", newJString(userIp))
  add(query_579148, "quotaUser", newJString(quotaUser))
  add(query_579148, "pageToken", newJString(pageToken))
  add(path_579147, "zone", newJString(zone))
  add(path_579147, "projectName", newJString(projectName))
  add(query_579148, "fields", newJString(fields))
  add(query_579148, "maxResults", newJInt(maxResults))
  result = call_579146.call(path_579147, query_579148, nil, nil, nil)

var resourceviewsZoneViewsListresources* = Call_ResourceviewsZoneViewsListresources_579130(
    name: "resourceviewsZoneViewsListresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}/resources",
    validator: validate_ResourceviewsZoneViewsListresources_579131,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsListresources_579132, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
