
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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
  Call_ResourceviewsRegionViewsInsert_589013 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsRegionViewsInsert_589015(protocol: Scheme; host: string;
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

proc validate_ResourceviewsRegionViewsInsert_589014(path: JsonNode;
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
  var valid_589016 = path.getOrDefault("projectName")
  valid_589016 = validateParameter(valid_589016, JString, required = true,
                                 default = nil)
  if valid_589016 != nil:
    section.add "projectName", valid_589016
  var valid_589017 = path.getOrDefault("region")
  valid_589017 = validateParameter(valid_589017, JString, required = true,
                                 default = nil)
  if valid_589017 != nil:
    section.add "region", valid_589017
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
  var valid_589018 = query.getOrDefault("fields")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "fields", valid_589018
  var valid_589019 = query.getOrDefault("quotaUser")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "quotaUser", valid_589019
  var valid_589020 = query.getOrDefault("alt")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("json"))
  if valid_589020 != nil:
    section.add "alt", valid_589020
  var valid_589021 = query.getOrDefault("oauth_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "oauth_token", valid_589021
  var valid_589022 = query.getOrDefault("userIp")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "userIp", valid_589022
  var valid_589023 = query.getOrDefault("key")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "key", valid_589023
  var valid_589024 = query.getOrDefault("prettyPrint")
  valid_589024 = validateParameter(valid_589024, JBool, required = false,
                                 default = newJBool(true))
  if valid_589024 != nil:
    section.add "prettyPrint", valid_589024
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

proc call*(call_589026: Call_ResourceviewsRegionViewsInsert_589013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource view.
  ## 
  let valid = call_589026.validator(path, query, header, formData, body)
  let scheme = call_589026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589026.url(scheme.get, call_589026.host, call_589026.base,
                         call_589026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589026, url, valid)

proc call*(call_589027: Call_ResourceviewsRegionViewsInsert_589013;
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
  var path_589028 = newJObject()
  var query_589029 = newJObject()
  var body_589030 = newJObject()
  add(query_589029, "fields", newJString(fields))
  add(query_589029, "quotaUser", newJString(quotaUser))
  add(query_589029, "alt", newJString(alt))
  add(query_589029, "oauth_token", newJString(oauthToken))
  add(query_589029, "userIp", newJString(userIp))
  add(query_589029, "key", newJString(key))
  add(path_589028, "projectName", newJString(projectName))
  add(path_589028, "region", newJString(region))
  if body != nil:
    body_589030 = body
  add(query_589029, "prettyPrint", newJBool(prettyPrint))
  result = call_589027.call(path_589028, query_589029, nil, nil, body_589030)

var resourceviewsRegionViewsInsert* = Call_ResourceviewsRegionViewsInsert_589013(
    name: "resourceviewsRegionViewsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews",
    validator: validate_ResourceviewsRegionViewsInsert_589014,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsInsert_589015, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsList_588725 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsRegionViewsList_588727(protocol: Scheme; host: string;
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

proc validate_ResourceviewsRegionViewsList_588726(path: JsonNode; query: JsonNode;
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
  var valid_588853 = path.getOrDefault("projectName")
  valid_588853 = validateParameter(valid_588853, JString, required = true,
                                 default = nil)
  if valid_588853 != nil:
    section.add "projectName", valid_588853
  var valid_588854 = path.getOrDefault("region")
  valid_588854 = validateParameter(valid_588854, JString, required = true,
                                 default = nil)
  if valid_588854 != nil:
    section.add "region", valid_588854
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
  var valid_588855 = query.getOrDefault("fields")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "fields", valid_588855
  var valid_588856 = query.getOrDefault("pageToken")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "pageToken", valid_588856
  var valid_588857 = query.getOrDefault("quotaUser")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "quotaUser", valid_588857
  var valid_588871 = query.getOrDefault("alt")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = newJString("json"))
  if valid_588871 != nil:
    section.add "alt", valid_588871
  var valid_588872 = query.getOrDefault("oauth_token")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "oauth_token", valid_588872
  var valid_588873 = query.getOrDefault("userIp")
  valid_588873 = validateParameter(valid_588873, JString, required = false,
                                 default = nil)
  if valid_588873 != nil:
    section.add "userIp", valid_588873
  var valid_588875 = query.getOrDefault("maxResults")
  valid_588875 = validateParameter(valid_588875, JInt, required = false,
                                 default = newJInt(5000))
  if valid_588875 != nil:
    section.add "maxResults", valid_588875
  var valid_588876 = query.getOrDefault("key")
  valid_588876 = validateParameter(valid_588876, JString, required = false,
                                 default = nil)
  if valid_588876 != nil:
    section.add "key", valid_588876
  var valid_588877 = query.getOrDefault("prettyPrint")
  valid_588877 = validateParameter(valid_588877, JBool, required = false,
                                 default = newJBool(true))
  if valid_588877 != nil:
    section.add "prettyPrint", valid_588877
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588900: Call_ResourceviewsRegionViewsList_588725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List resource views.
  ## 
  let valid = call_588900.validator(path, query, header, formData, body)
  let scheme = call_588900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588900.url(scheme.get, call_588900.host, call_588900.base,
                         call_588900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588900, url, valid)

proc call*(call_588971: Call_ResourceviewsRegionViewsList_588725;
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
  var path_588972 = newJObject()
  var query_588974 = newJObject()
  add(query_588974, "fields", newJString(fields))
  add(query_588974, "pageToken", newJString(pageToken))
  add(query_588974, "quotaUser", newJString(quotaUser))
  add(query_588974, "alt", newJString(alt))
  add(query_588974, "oauth_token", newJString(oauthToken))
  add(query_588974, "userIp", newJString(userIp))
  add(query_588974, "maxResults", newJInt(maxResults))
  add(query_588974, "key", newJString(key))
  add(path_588972, "projectName", newJString(projectName))
  add(path_588972, "region", newJString(region))
  add(query_588974, "prettyPrint", newJBool(prettyPrint))
  result = call_588971.call(path_588972, query_588974, nil, nil, nil)

var resourceviewsRegionViewsList* = Call_ResourceviewsRegionViewsList_588725(
    name: "resourceviewsRegionViewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews",
    validator: validate_ResourceviewsRegionViewsList_588726,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsList_588727, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsGet_589031 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsRegionViewsGet_589033(protocol: Scheme; host: string;
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

proc validate_ResourceviewsRegionViewsGet_589032(path: JsonNode; query: JsonNode;
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
  var valid_589034 = path.getOrDefault("resourceViewName")
  valid_589034 = validateParameter(valid_589034, JString, required = true,
                                 default = nil)
  if valid_589034 != nil:
    section.add "resourceViewName", valid_589034
  var valid_589035 = path.getOrDefault("projectName")
  valid_589035 = validateParameter(valid_589035, JString, required = true,
                                 default = nil)
  if valid_589035 != nil:
    section.add "projectName", valid_589035
  var valid_589036 = path.getOrDefault("region")
  valid_589036 = validateParameter(valid_589036, JString, required = true,
                                 default = nil)
  if valid_589036 != nil:
    section.add "region", valid_589036
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
  var valid_589037 = query.getOrDefault("fields")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "fields", valid_589037
  var valid_589038 = query.getOrDefault("quotaUser")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "quotaUser", valid_589038
  var valid_589039 = query.getOrDefault("alt")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("json"))
  if valid_589039 != nil:
    section.add "alt", valid_589039
  var valid_589040 = query.getOrDefault("oauth_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "oauth_token", valid_589040
  var valid_589041 = query.getOrDefault("userIp")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "userIp", valid_589041
  var valid_589042 = query.getOrDefault("key")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "key", valid_589042
  var valid_589043 = query.getOrDefault("prettyPrint")
  valid_589043 = validateParameter(valid_589043, JBool, required = false,
                                 default = newJBool(true))
  if valid_589043 != nil:
    section.add "prettyPrint", valid_589043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589044: Call_ResourceviewsRegionViewsGet_589031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information of a resource view.
  ## 
  let valid = call_589044.validator(path, query, header, formData, body)
  let scheme = call_589044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589044.url(scheme.get, call_589044.host, call_589044.base,
                         call_589044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589044, url, valid)

proc call*(call_589045: Call_ResourceviewsRegionViewsGet_589031;
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
  var path_589046 = newJObject()
  var query_589047 = newJObject()
  add(query_589047, "fields", newJString(fields))
  add(query_589047, "quotaUser", newJString(quotaUser))
  add(query_589047, "alt", newJString(alt))
  add(query_589047, "oauth_token", newJString(oauthToken))
  add(path_589046, "resourceViewName", newJString(resourceViewName))
  add(query_589047, "userIp", newJString(userIp))
  add(query_589047, "key", newJString(key))
  add(path_589046, "projectName", newJString(projectName))
  add(path_589046, "region", newJString(region))
  add(query_589047, "prettyPrint", newJBool(prettyPrint))
  result = call_589045.call(path_589046, query_589047, nil, nil, nil)

var resourceviewsRegionViewsGet* = Call_ResourceviewsRegionViewsGet_589031(
    name: "resourceviewsRegionViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsRegionViewsGet_589032,
    base: "/resourceviews/v1beta1/projects", url: url_ResourceviewsRegionViewsGet_589033,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsDelete_589048 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsRegionViewsDelete_589050(protocol: Scheme; host: string;
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

proc validate_ResourceviewsRegionViewsDelete_589049(path: JsonNode;
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
  var valid_589051 = path.getOrDefault("resourceViewName")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "resourceViewName", valid_589051
  var valid_589052 = path.getOrDefault("projectName")
  valid_589052 = validateParameter(valid_589052, JString, required = true,
                                 default = nil)
  if valid_589052 != nil:
    section.add "projectName", valid_589052
  var valid_589053 = path.getOrDefault("region")
  valid_589053 = validateParameter(valid_589053, JString, required = true,
                                 default = nil)
  if valid_589053 != nil:
    section.add "region", valid_589053
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
  var valid_589054 = query.getOrDefault("fields")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "fields", valid_589054
  var valid_589055 = query.getOrDefault("quotaUser")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "quotaUser", valid_589055
  var valid_589056 = query.getOrDefault("alt")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("json"))
  if valid_589056 != nil:
    section.add "alt", valid_589056
  var valid_589057 = query.getOrDefault("oauth_token")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "oauth_token", valid_589057
  var valid_589058 = query.getOrDefault("userIp")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "userIp", valid_589058
  var valid_589059 = query.getOrDefault("key")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "key", valid_589059
  var valid_589060 = query.getOrDefault("prettyPrint")
  valid_589060 = validateParameter(valid_589060, JBool, required = false,
                                 default = newJBool(true))
  if valid_589060 != nil:
    section.add "prettyPrint", valid_589060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589061: Call_ResourceviewsRegionViewsDelete_589048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a resource view.
  ## 
  let valid = call_589061.validator(path, query, header, formData, body)
  let scheme = call_589061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589061.url(scheme.get, call_589061.host, call_589061.base,
                         call_589061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589061, url, valid)

proc call*(call_589062: Call_ResourceviewsRegionViewsDelete_589048;
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
  var path_589063 = newJObject()
  var query_589064 = newJObject()
  add(query_589064, "fields", newJString(fields))
  add(query_589064, "quotaUser", newJString(quotaUser))
  add(query_589064, "alt", newJString(alt))
  add(query_589064, "oauth_token", newJString(oauthToken))
  add(path_589063, "resourceViewName", newJString(resourceViewName))
  add(query_589064, "userIp", newJString(userIp))
  add(query_589064, "key", newJString(key))
  add(path_589063, "projectName", newJString(projectName))
  add(path_589063, "region", newJString(region))
  add(query_589064, "prettyPrint", newJBool(prettyPrint))
  result = call_589062.call(path_589063, query_589064, nil, nil, nil)

var resourceviewsRegionViewsDelete* = Call_ResourceviewsRegionViewsDelete_589048(
    name: "resourceviewsRegionViewsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsRegionViewsDelete_589049,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsDelete_589050, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsAddresources_589065 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsRegionViewsAddresources_589067(protocol: Scheme;
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

proc validate_ResourceviewsRegionViewsAddresources_589066(path: JsonNode;
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
  var valid_589068 = path.getOrDefault("resourceViewName")
  valid_589068 = validateParameter(valid_589068, JString, required = true,
                                 default = nil)
  if valid_589068 != nil:
    section.add "resourceViewName", valid_589068
  var valid_589069 = path.getOrDefault("projectName")
  valid_589069 = validateParameter(valid_589069, JString, required = true,
                                 default = nil)
  if valid_589069 != nil:
    section.add "projectName", valid_589069
  var valid_589070 = path.getOrDefault("region")
  valid_589070 = validateParameter(valid_589070, JString, required = true,
                                 default = nil)
  if valid_589070 != nil:
    section.add "region", valid_589070
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
  var valid_589071 = query.getOrDefault("fields")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "fields", valid_589071
  var valid_589072 = query.getOrDefault("quotaUser")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "quotaUser", valid_589072
  var valid_589073 = query.getOrDefault("alt")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = newJString("json"))
  if valid_589073 != nil:
    section.add "alt", valid_589073
  var valid_589074 = query.getOrDefault("oauth_token")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "oauth_token", valid_589074
  var valid_589075 = query.getOrDefault("userIp")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "userIp", valid_589075
  var valid_589076 = query.getOrDefault("key")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "key", valid_589076
  var valid_589077 = query.getOrDefault("prettyPrint")
  valid_589077 = validateParameter(valid_589077, JBool, required = false,
                                 default = newJBool(true))
  if valid_589077 != nil:
    section.add "prettyPrint", valid_589077
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

proc call*(call_589079: Call_ResourceviewsRegionViewsAddresources_589065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add resources to the view.
  ## 
  let valid = call_589079.validator(path, query, header, formData, body)
  let scheme = call_589079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589079.url(scheme.get, call_589079.host, call_589079.base,
                         call_589079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589079, url, valid)

proc call*(call_589080: Call_ResourceviewsRegionViewsAddresources_589065;
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
  var path_589081 = newJObject()
  var query_589082 = newJObject()
  var body_589083 = newJObject()
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(path_589081, "resourceViewName", newJString(resourceViewName))
  add(query_589082, "userIp", newJString(userIp))
  add(query_589082, "key", newJString(key))
  add(path_589081, "projectName", newJString(projectName))
  add(path_589081, "region", newJString(region))
  if body != nil:
    body_589083 = body
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  result = call_589080.call(path_589081, query_589082, nil, nil, body_589083)

var resourceviewsRegionViewsAddresources* = Call_ResourceviewsRegionViewsAddresources_589065(
    name: "resourceviewsRegionViewsAddresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}/addResources",
    validator: validate_ResourceviewsRegionViewsAddresources_589066,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsAddresources_589067, schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsRemoveresources_589084 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsRegionViewsRemoveresources_589086(protocol: Scheme;
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

proc validate_ResourceviewsRegionViewsRemoveresources_589085(path: JsonNode;
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
  var valid_589087 = path.getOrDefault("resourceViewName")
  valid_589087 = validateParameter(valid_589087, JString, required = true,
                                 default = nil)
  if valid_589087 != nil:
    section.add "resourceViewName", valid_589087
  var valid_589088 = path.getOrDefault("projectName")
  valid_589088 = validateParameter(valid_589088, JString, required = true,
                                 default = nil)
  if valid_589088 != nil:
    section.add "projectName", valid_589088
  var valid_589089 = path.getOrDefault("region")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "region", valid_589089
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
  var valid_589090 = query.getOrDefault("fields")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "fields", valid_589090
  var valid_589091 = query.getOrDefault("quotaUser")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "quotaUser", valid_589091
  var valid_589092 = query.getOrDefault("alt")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("json"))
  if valid_589092 != nil:
    section.add "alt", valid_589092
  var valid_589093 = query.getOrDefault("oauth_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "oauth_token", valid_589093
  var valid_589094 = query.getOrDefault("userIp")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "userIp", valid_589094
  var valid_589095 = query.getOrDefault("key")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "key", valid_589095
  var valid_589096 = query.getOrDefault("prettyPrint")
  valid_589096 = validateParameter(valid_589096, JBool, required = false,
                                 default = newJBool(true))
  if valid_589096 != nil:
    section.add "prettyPrint", valid_589096
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

proc call*(call_589098: Call_ResourceviewsRegionViewsRemoveresources_589084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove resources from the view.
  ## 
  let valid = call_589098.validator(path, query, header, formData, body)
  let scheme = call_589098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589098.url(scheme.get, call_589098.host, call_589098.base,
                         call_589098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589098, url, valid)

proc call*(call_589099: Call_ResourceviewsRegionViewsRemoveresources_589084;
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
  var path_589100 = newJObject()
  var query_589101 = newJObject()
  var body_589102 = newJObject()
  add(query_589101, "fields", newJString(fields))
  add(query_589101, "quotaUser", newJString(quotaUser))
  add(query_589101, "alt", newJString(alt))
  add(query_589101, "oauth_token", newJString(oauthToken))
  add(path_589100, "resourceViewName", newJString(resourceViewName))
  add(query_589101, "userIp", newJString(userIp))
  add(query_589101, "key", newJString(key))
  add(path_589100, "projectName", newJString(projectName))
  add(path_589100, "region", newJString(region))
  if body != nil:
    body_589102 = body
  add(query_589101, "prettyPrint", newJBool(prettyPrint))
  result = call_589099.call(path_589100, query_589101, nil, nil, body_589102)

var resourceviewsRegionViewsRemoveresources* = Call_ResourceviewsRegionViewsRemoveresources_589084(
    name: "resourceviewsRegionViewsRemoveresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}/removeResources",
    validator: validate_ResourceviewsRegionViewsRemoveresources_589085,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsRemoveresources_589086,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsRegionViewsListresources_589103 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsRegionViewsListresources_589105(protocol: Scheme;
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

proc validate_ResourceviewsRegionViewsListresources_589104(path: JsonNode;
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
  var valid_589106 = path.getOrDefault("resourceViewName")
  valid_589106 = validateParameter(valid_589106, JString, required = true,
                                 default = nil)
  if valid_589106 != nil:
    section.add "resourceViewName", valid_589106
  var valid_589107 = path.getOrDefault("projectName")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "projectName", valid_589107
  var valid_589108 = path.getOrDefault("region")
  valid_589108 = validateParameter(valid_589108, JString, required = true,
                                 default = nil)
  if valid_589108 != nil:
    section.add "region", valid_589108
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
  var valid_589109 = query.getOrDefault("fields")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "fields", valid_589109
  var valid_589110 = query.getOrDefault("pageToken")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "pageToken", valid_589110
  var valid_589111 = query.getOrDefault("quotaUser")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "quotaUser", valid_589111
  var valid_589112 = query.getOrDefault("alt")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = newJString("json"))
  if valid_589112 != nil:
    section.add "alt", valid_589112
  var valid_589113 = query.getOrDefault("oauth_token")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "oauth_token", valid_589113
  var valid_589114 = query.getOrDefault("userIp")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "userIp", valid_589114
  var valid_589115 = query.getOrDefault("maxResults")
  valid_589115 = validateParameter(valid_589115, JInt, required = false,
                                 default = newJInt(5000))
  if valid_589115 != nil:
    section.add "maxResults", valid_589115
  var valid_589116 = query.getOrDefault("key")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "key", valid_589116
  var valid_589117 = query.getOrDefault("prettyPrint")
  valid_589117 = validateParameter(valid_589117, JBool, required = false,
                                 default = newJBool(true))
  if valid_589117 != nil:
    section.add "prettyPrint", valid_589117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589118: Call_ResourceviewsRegionViewsListresources_589103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the resources in the view.
  ## 
  let valid = call_589118.validator(path, query, header, formData, body)
  let scheme = call_589118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589118.url(scheme.get, call_589118.host, call_589118.base,
                         call_589118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589118, url, valid)

proc call*(call_589119: Call_ResourceviewsRegionViewsListresources_589103;
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
  var path_589120 = newJObject()
  var query_589121 = newJObject()
  add(query_589121, "fields", newJString(fields))
  add(query_589121, "pageToken", newJString(pageToken))
  add(query_589121, "quotaUser", newJString(quotaUser))
  add(query_589121, "alt", newJString(alt))
  add(query_589121, "oauth_token", newJString(oauthToken))
  add(path_589120, "resourceViewName", newJString(resourceViewName))
  add(query_589121, "userIp", newJString(userIp))
  add(query_589121, "maxResults", newJInt(maxResults))
  add(query_589121, "key", newJString(key))
  add(path_589120, "projectName", newJString(projectName))
  add(path_589120, "region", newJString(region))
  add(query_589121, "prettyPrint", newJBool(prettyPrint))
  result = call_589119.call(path_589120, query_589121, nil, nil, nil)

var resourceviewsRegionViewsListresources* = Call_ResourceviewsRegionViewsListresources_589103(
    name: "resourceviewsRegionViewsListresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/regions/{region}/resourceViews/{resourceViewName}/resources",
    validator: validate_ResourceviewsRegionViewsListresources_589104,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsRegionViewsListresources_589105, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsInsert_589140 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsInsert_589142(protocol: Scheme; host: string;
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

proc validate_ResourceviewsZoneViewsInsert_589141(path: JsonNode; query: JsonNode;
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
  var valid_589143 = path.getOrDefault("zone")
  valid_589143 = validateParameter(valid_589143, JString, required = true,
                                 default = nil)
  if valid_589143 != nil:
    section.add "zone", valid_589143
  var valid_589144 = path.getOrDefault("projectName")
  valid_589144 = validateParameter(valid_589144, JString, required = true,
                                 default = nil)
  if valid_589144 != nil:
    section.add "projectName", valid_589144
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
  var valid_589145 = query.getOrDefault("fields")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "fields", valid_589145
  var valid_589146 = query.getOrDefault("quotaUser")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "quotaUser", valid_589146
  var valid_589147 = query.getOrDefault("alt")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = newJString("json"))
  if valid_589147 != nil:
    section.add "alt", valid_589147
  var valid_589148 = query.getOrDefault("oauth_token")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "oauth_token", valid_589148
  var valid_589149 = query.getOrDefault("userIp")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "userIp", valid_589149
  var valid_589150 = query.getOrDefault("key")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "key", valid_589150
  var valid_589151 = query.getOrDefault("prettyPrint")
  valid_589151 = validateParameter(valid_589151, JBool, required = false,
                                 default = newJBool(true))
  if valid_589151 != nil:
    section.add "prettyPrint", valid_589151
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

proc call*(call_589153: Call_ResourceviewsZoneViewsInsert_589140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource view.
  ## 
  let valid = call_589153.validator(path, query, header, formData, body)
  let scheme = call_589153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589153.url(scheme.get, call_589153.host, call_589153.base,
                         call_589153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589153, url, valid)

proc call*(call_589154: Call_ResourceviewsZoneViewsInsert_589140; zone: string;
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
  var path_589155 = newJObject()
  var query_589156 = newJObject()
  var body_589157 = newJObject()
  add(path_589155, "zone", newJString(zone))
  add(query_589156, "fields", newJString(fields))
  add(query_589156, "quotaUser", newJString(quotaUser))
  add(query_589156, "alt", newJString(alt))
  add(query_589156, "oauth_token", newJString(oauthToken))
  add(query_589156, "userIp", newJString(userIp))
  add(query_589156, "key", newJString(key))
  add(path_589155, "projectName", newJString(projectName))
  if body != nil:
    body_589157 = body
  add(query_589156, "prettyPrint", newJBool(prettyPrint))
  result = call_589154.call(path_589155, query_589156, nil, nil, body_589157)

var resourceviewsZoneViewsInsert* = Call_ResourceviewsZoneViewsInsert_589140(
    name: "resourceviewsZoneViewsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews",
    validator: validate_ResourceviewsZoneViewsInsert_589141,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsInsert_589142, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsList_589122 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsList_589124(protocol: Scheme; host: string;
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

proc validate_ResourceviewsZoneViewsList_589123(path: JsonNode; query: JsonNode;
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
  var valid_589125 = path.getOrDefault("zone")
  valid_589125 = validateParameter(valid_589125, JString, required = true,
                                 default = nil)
  if valid_589125 != nil:
    section.add "zone", valid_589125
  var valid_589126 = path.getOrDefault("projectName")
  valid_589126 = validateParameter(valid_589126, JString, required = true,
                                 default = nil)
  if valid_589126 != nil:
    section.add "projectName", valid_589126
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
  var valid_589127 = query.getOrDefault("fields")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "fields", valid_589127
  var valid_589128 = query.getOrDefault("pageToken")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "pageToken", valid_589128
  var valid_589129 = query.getOrDefault("quotaUser")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "quotaUser", valid_589129
  var valid_589130 = query.getOrDefault("alt")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = newJString("json"))
  if valid_589130 != nil:
    section.add "alt", valid_589130
  var valid_589131 = query.getOrDefault("oauth_token")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "oauth_token", valid_589131
  var valid_589132 = query.getOrDefault("userIp")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "userIp", valid_589132
  var valid_589133 = query.getOrDefault("maxResults")
  valid_589133 = validateParameter(valid_589133, JInt, required = false,
                                 default = newJInt(5000))
  if valid_589133 != nil:
    section.add "maxResults", valid_589133
  var valid_589134 = query.getOrDefault("key")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "key", valid_589134
  var valid_589135 = query.getOrDefault("prettyPrint")
  valid_589135 = validateParameter(valid_589135, JBool, required = false,
                                 default = newJBool(true))
  if valid_589135 != nil:
    section.add "prettyPrint", valid_589135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589136: Call_ResourceviewsZoneViewsList_589122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List resource views.
  ## 
  let valid = call_589136.validator(path, query, header, formData, body)
  let scheme = call_589136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589136.url(scheme.get, call_589136.host, call_589136.base,
                         call_589136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589136, url, valid)

proc call*(call_589137: Call_ResourceviewsZoneViewsList_589122; zone: string;
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
  var path_589138 = newJObject()
  var query_589139 = newJObject()
  add(path_589138, "zone", newJString(zone))
  add(query_589139, "fields", newJString(fields))
  add(query_589139, "pageToken", newJString(pageToken))
  add(query_589139, "quotaUser", newJString(quotaUser))
  add(query_589139, "alt", newJString(alt))
  add(query_589139, "oauth_token", newJString(oauthToken))
  add(query_589139, "userIp", newJString(userIp))
  add(query_589139, "maxResults", newJInt(maxResults))
  add(query_589139, "key", newJString(key))
  add(path_589138, "projectName", newJString(projectName))
  add(query_589139, "prettyPrint", newJBool(prettyPrint))
  result = call_589137.call(path_589138, query_589139, nil, nil, nil)

var resourceviewsZoneViewsList* = Call_ResourceviewsZoneViewsList_589122(
    name: "resourceviewsZoneViewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews",
    validator: validate_ResourceviewsZoneViewsList_589123,
    base: "/resourceviews/v1beta1/projects", url: url_ResourceviewsZoneViewsList_589124,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsGet_589158 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsGet_589160(protocol: Scheme; host: string;
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

proc validate_ResourceviewsZoneViewsGet_589159(path: JsonNode; query: JsonNode;
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
  var valid_589161 = path.getOrDefault("zone")
  valid_589161 = validateParameter(valid_589161, JString, required = true,
                                 default = nil)
  if valid_589161 != nil:
    section.add "zone", valid_589161
  var valid_589162 = path.getOrDefault("resourceViewName")
  valid_589162 = validateParameter(valid_589162, JString, required = true,
                                 default = nil)
  if valid_589162 != nil:
    section.add "resourceViewName", valid_589162
  var valid_589163 = path.getOrDefault("projectName")
  valid_589163 = validateParameter(valid_589163, JString, required = true,
                                 default = nil)
  if valid_589163 != nil:
    section.add "projectName", valid_589163
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
  var valid_589164 = query.getOrDefault("fields")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "fields", valid_589164
  var valid_589165 = query.getOrDefault("quotaUser")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "quotaUser", valid_589165
  var valid_589166 = query.getOrDefault("alt")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = newJString("json"))
  if valid_589166 != nil:
    section.add "alt", valid_589166
  var valid_589167 = query.getOrDefault("oauth_token")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "oauth_token", valid_589167
  var valid_589168 = query.getOrDefault("userIp")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "userIp", valid_589168
  var valid_589169 = query.getOrDefault("key")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "key", valid_589169
  var valid_589170 = query.getOrDefault("prettyPrint")
  valid_589170 = validateParameter(valid_589170, JBool, required = false,
                                 default = newJBool(true))
  if valid_589170 != nil:
    section.add "prettyPrint", valid_589170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589171: Call_ResourceviewsZoneViewsGet_589158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information of a zonal resource view.
  ## 
  let valid = call_589171.validator(path, query, header, formData, body)
  let scheme = call_589171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589171.url(scheme.get, call_589171.host, call_589171.base,
                         call_589171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589171, url, valid)

proc call*(call_589172: Call_ResourceviewsZoneViewsGet_589158; zone: string;
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
  var path_589173 = newJObject()
  var query_589174 = newJObject()
  add(path_589173, "zone", newJString(zone))
  add(query_589174, "fields", newJString(fields))
  add(query_589174, "quotaUser", newJString(quotaUser))
  add(query_589174, "alt", newJString(alt))
  add(query_589174, "oauth_token", newJString(oauthToken))
  add(path_589173, "resourceViewName", newJString(resourceViewName))
  add(query_589174, "userIp", newJString(userIp))
  add(query_589174, "key", newJString(key))
  add(path_589173, "projectName", newJString(projectName))
  add(query_589174, "prettyPrint", newJBool(prettyPrint))
  result = call_589172.call(path_589173, query_589174, nil, nil, nil)

var resourceviewsZoneViewsGet* = Call_ResourceviewsZoneViewsGet_589158(
    name: "resourceviewsZoneViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsZoneViewsGet_589159,
    base: "/resourceviews/v1beta1/projects", url: url_ResourceviewsZoneViewsGet_589160,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsDelete_589175 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsDelete_589177(protocol: Scheme; host: string;
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

proc validate_ResourceviewsZoneViewsDelete_589176(path: JsonNode; query: JsonNode;
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
  var valid_589178 = path.getOrDefault("zone")
  valid_589178 = validateParameter(valid_589178, JString, required = true,
                                 default = nil)
  if valid_589178 != nil:
    section.add "zone", valid_589178
  var valid_589179 = path.getOrDefault("resourceViewName")
  valid_589179 = validateParameter(valid_589179, JString, required = true,
                                 default = nil)
  if valid_589179 != nil:
    section.add "resourceViewName", valid_589179
  var valid_589180 = path.getOrDefault("projectName")
  valid_589180 = validateParameter(valid_589180, JString, required = true,
                                 default = nil)
  if valid_589180 != nil:
    section.add "projectName", valid_589180
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
  var valid_589181 = query.getOrDefault("fields")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "fields", valid_589181
  var valid_589182 = query.getOrDefault("quotaUser")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "quotaUser", valid_589182
  var valid_589183 = query.getOrDefault("alt")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = newJString("json"))
  if valid_589183 != nil:
    section.add "alt", valid_589183
  var valid_589184 = query.getOrDefault("oauth_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "oauth_token", valid_589184
  var valid_589185 = query.getOrDefault("userIp")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "userIp", valid_589185
  var valid_589186 = query.getOrDefault("key")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "key", valid_589186
  var valid_589187 = query.getOrDefault("prettyPrint")
  valid_589187 = validateParameter(valid_589187, JBool, required = false,
                                 default = newJBool(true))
  if valid_589187 != nil:
    section.add "prettyPrint", valid_589187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589188: Call_ResourceviewsZoneViewsDelete_589175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a resource view.
  ## 
  let valid = call_589188.validator(path, query, header, formData, body)
  let scheme = call_589188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589188.url(scheme.get, call_589188.host, call_589188.base,
                         call_589188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589188, url, valid)

proc call*(call_589189: Call_ResourceviewsZoneViewsDelete_589175; zone: string;
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
  var path_589190 = newJObject()
  var query_589191 = newJObject()
  add(path_589190, "zone", newJString(zone))
  add(query_589191, "fields", newJString(fields))
  add(query_589191, "quotaUser", newJString(quotaUser))
  add(query_589191, "alt", newJString(alt))
  add(query_589191, "oauth_token", newJString(oauthToken))
  add(path_589190, "resourceViewName", newJString(resourceViewName))
  add(query_589191, "userIp", newJString(userIp))
  add(query_589191, "key", newJString(key))
  add(path_589190, "projectName", newJString(projectName))
  add(query_589191, "prettyPrint", newJBool(prettyPrint))
  result = call_589189.call(path_589190, query_589191, nil, nil, nil)

var resourceviewsZoneViewsDelete* = Call_ResourceviewsZoneViewsDelete_589175(
    name: "resourceviewsZoneViewsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}",
    validator: validate_ResourceviewsZoneViewsDelete_589176,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsDelete_589177, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsAddresources_589192 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsAddresources_589194(protocol: Scheme; host: string;
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

proc validate_ResourceviewsZoneViewsAddresources_589193(path: JsonNode;
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
  var valid_589195 = path.getOrDefault("zone")
  valid_589195 = validateParameter(valid_589195, JString, required = true,
                                 default = nil)
  if valid_589195 != nil:
    section.add "zone", valid_589195
  var valid_589196 = path.getOrDefault("resourceViewName")
  valid_589196 = validateParameter(valid_589196, JString, required = true,
                                 default = nil)
  if valid_589196 != nil:
    section.add "resourceViewName", valid_589196
  var valid_589197 = path.getOrDefault("projectName")
  valid_589197 = validateParameter(valid_589197, JString, required = true,
                                 default = nil)
  if valid_589197 != nil:
    section.add "projectName", valid_589197
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
  var valid_589198 = query.getOrDefault("fields")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "fields", valid_589198
  var valid_589199 = query.getOrDefault("quotaUser")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "quotaUser", valid_589199
  var valid_589200 = query.getOrDefault("alt")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = newJString("json"))
  if valid_589200 != nil:
    section.add "alt", valid_589200
  var valid_589201 = query.getOrDefault("oauth_token")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "oauth_token", valid_589201
  var valid_589202 = query.getOrDefault("userIp")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "userIp", valid_589202
  var valid_589203 = query.getOrDefault("key")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "key", valid_589203
  var valid_589204 = query.getOrDefault("prettyPrint")
  valid_589204 = validateParameter(valid_589204, JBool, required = false,
                                 default = newJBool(true))
  if valid_589204 != nil:
    section.add "prettyPrint", valid_589204
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

proc call*(call_589206: Call_ResourceviewsZoneViewsAddresources_589192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add resources to the view.
  ## 
  let valid = call_589206.validator(path, query, header, formData, body)
  let scheme = call_589206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589206.url(scheme.get, call_589206.host, call_589206.base,
                         call_589206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589206, url, valid)

proc call*(call_589207: Call_ResourceviewsZoneViewsAddresources_589192;
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
  var path_589208 = newJObject()
  var query_589209 = newJObject()
  var body_589210 = newJObject()
  add(path_589208, "zone", newJString(zone))
  add(query_589209, "fields", newJString(fields))
  add(query_589209, "quotaUser", newJString(quotaUser))
  add(query_589209, "alt", newJString(alt))
  add(query_589209, "oauth_token", newJString(oauthToken))
  add(path_589208, "resourceViewName", newJString(resourceViewName))
  add(query_589209, "userIp", newJString(userIp))
  add(query_589209, "key", newJString(key))
  add(path_589208, "projectName", newJString(projectName))
  if body != nil:
    body_589210 = body
  add(query_589209, "prettyPrint", newJBool(prettyPrint))
  result = call_589207.call(path_589208, query_589209, nil, nil, body_589210)

var resourceviewsZoneViewsAddresources* = Call_ResourceviewsZoneViewsAddresources_589192(
    name: "resourceviewsZoneViewsAddresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}/addResources",
    validator: validate_ResourceviewsZoneViewsAddresources_589193,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsAddresources_589194, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsRemoveresources_589211 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsRemoveresources_589213(protocol: Scheme;
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

proc validate_ResourceviewsZoneViewsRemoveresources_589212(path: JsonNode;
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
  var valid_589214 = path.getOrDefault("zone")
  valid_589214 = validateParameter(valid_589214, JString, required = true,
                                 default = nil)
  if valid_589214 != nil:
    section.add "zone", valid_589214
  var valid_589215 = path.getOrDefault("resourceViewName")
  valid_589215 = validateParameter(valid_589215, JString, required = true,
                                 default = nil)
  if valid_589215 != nil:
    section.add "resourceViewName", valid_589215
  var valid_589216 = path.getOrDefault("projectName")
  valid_589216 = validateParameter(valid_589216, JString, required = true,
                                 default = nil)
  if valid_589216 != nil:
    section.add "projectName", valid_589216
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
  var valid_589217 = query.getOrDefault("fields")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "fields", valid_589217
  var valid_589218 = query.getOrDefault("quotaUser")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "quotaUser", valid_589218
  var valid_589219 = query.getOrDefault("alt")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = newJString("json"))
  if valid_589219 != nil:
    section.add "alt", valid_589219
  var valid_589220 = query.getOrDefault("oauth_token")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "oauth_token", valid_589220
  var valid_589221 = query.getOrDefault("userIp")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "userIp", valid_589221
  var valid_589222 = query.getOrDefault("key")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "key", valid_589222
  var valid_589223 = query.getOrDefault("prettyPrint")
  valid_589223 = validateParameter(valid_589223, JBool, required = false,
                                 default = newJBool(true))
  if valid_589223 != nil:
    section.add "prettyPrint", valid_589223
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

proc call*(call_589225: Call_ResourceviewsZoneViewsRemoveresources_589211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove resources from the view.
  ## 
  let valid = call_589225.validator(path, query, header, formData, body)
  let scheme = call_589225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589225.url(scheme.get, call_589225.host, call_589225.base,
                         call_589225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589225, url, valid)

proc call*(call_589226: Call_ResourceviewsZoneViewsRemoveresources_589211;
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
  var path_589227 = newJObject()
  var query_589228 = newJObject()
  var body_589229 = newJObject()
  add(path_589227, "zone", newJString(zone))
  add(query_589228, "fields", newJString(fields))
  add(query_589228, "quotaUser", newJString(quotaUser))
  add(query_589228, "alt", newJString(alt))
  add(query_589228, "oauth_token", newJString(oauthToken))
  add(path_589227, "resourceViewName", newJString(resourceViewName))
  add(query_589228, "userIp", newJString(userIp))
  add(query_589228, "key", newJString(key))
  add(path_589227, "projectName", newJString(projectName))
  if body != nil:
    body_589229 = body
  add(query_589228, "prettyPrint", newJBool(prettyPrint))
  result = call_589226.call(path_589227, query_589228, nil, nil, body_589229)

var resourceviewsZoneViewsRemoveresources* = Call_ResourceviewsZoneViewsRemoveresources_589211(
    name: "resourceviewsZoneViewsRemoveresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}/removeResources",
    validator: validate_ResourceviewsZoneViewsRemoveresources_589212,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsRemoveresources_589213, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsListresources_589230 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsListresources_589232(protocol: Scheme; host: string;
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

proc validate_ResourceviewsZoneViewsListresources_589231(path: JsonNode;
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
  var valid_589233 = path.getOrDefault("zone")
  valid_589233 = validateParameter(valid_589233, JString, required = true,
                                 default = nil)
  if valid_589233 != nil:
    section.add "zone", valid_589233
  var valid_589234 = path.getOrDefault("resourceViewName")
  valid_589234 = validateParameter(valid_589234, JString, required = true,
                                 default = nil)
  if valid_589234 != nil:
    section.add "resourceViewName", valid_589234
  var valid_589235 = path.getOrDefault("projectName")
  valid_589235 = validateParameter(valid_589235, JString, required = true,
                                 default = nil)
  if valid_589235 != nil:
    section.add "projectName", valid_589235
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
  var valid_589236 = query.getOrDefault("fields")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "fields", valid_589236
  var valid_589237 = query.getOrDefault("pageToken")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "pageToken", valid_589237
  var valid_589238 = query.getOrDefault("quotaUser")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "quotaUser", valid_589238
  var valid_589239 = query.getOrDefault("alt")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = newJString("json"))
  if valid_589239 != nil:
    section.add "alt", valid_589239
  var valid_589240 = query.getOrDefault("oauth_token")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "oauth_token", valid_589240
  var valid_589241 = query.getOrDefault("userIp")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "userIp", valid_589241
  var valid_589242 = query.getOrDefault("maxResults")
  valid_589242 = validateParameter(valid_589242, JInt, required = false,
                                 default = newJInt(5000))
  if valid_589242 != nil:
    section.add "maxResults", valid_589242
  var valid_589243 = query.getOrDefault("key")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "key", valid_589243
  var valid_589244 = query.getOrDefault("prettyPrint")
  valid_589244 = validateParameter(valid_589244, JBool, required = false,
                                 default = newJBool(true))
  if valid_589244 != nil:
    section.add "prettyPrint", valid_589244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589245: Call_ResourceviewsZoneViewsListresources_589230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the resources of the resource view.
  ## 
  let valid = call_589245.validator(path, query, header, formData, body)
  let scheme = call_589245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589245.url(scheme.get, call_589245.host, call_589245.base,
                         call_589245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589245, url, valid)

proc call*(call_589246: Call_ResourceviewsZoneViewsListresources_589230;
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
  var path_589247 = newJObject()
  var query_589248 = newJObject()
  add(path_589247, "zone", newJString(zone))
  add(query_589248, "fields", newJString(fields))
  add(query_589248, "pageToken", newJString(pageToken))
  add(query_589248, "quotaUser", newJString(quotaUser))
  add(query_589248, "alt", newJString(alt))
  add(query_589248, "oauth_token", newJString(oauthToken))
  add(path_589247, "resourceViewName", newJString(resourceViewName))
  add(query_589248, "userIp", newJString(userIp))
  add(query_589248, "maxResults", newJInt(maxResults))
  add(query_589248, "key", newJString(key))
  add(path_589247, "projectName", newJString(projectName))
  add(query_589248, "prettyPrint", newJBool(prettyPrint))
  result = call_589246.call(path_589247, query_589248, nil, nil, nil)

var resourceviewsZoneViewsListresources* = Call_ResourceviewsZoneViewsListresources_589230(
    name: "resourceviewsZoneViewsListresources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{projectName}/zones/{zone}/resourceViews/{resourceViewName}/resources",
    validator: validate_ResourceviewsZoneViewsListresources_589231,
    base: "/resourceviews/v1beta1/projects",
    url: url_ResourceviewsZoneViewsListresources_589232, schemes: {Scheme.Https})
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
