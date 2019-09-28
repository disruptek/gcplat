
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Compute Engine Instance Groups
## version: v1beta2
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
  Call_ResourceviewsZoneOperationsList_579692 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneOperationsList_579694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneOperationsList_579693(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of operation resources contained within the specified zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Name of the zone scoping this request.
  ##   project: JString (required)
  ##          : Name of the project scoping this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_579820 = path.getOrDefault("zone")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "zone", valid_579820
  var valid_579821 = path.getOrDefault("project")
  valid_579821 = validateParameter(valid_579821, JString, required = true,
                                 default = nil)
  if valid_579821 != nil:
    section.add "project", valid_579821
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Filter expression for filtering listed resources.
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
                                 default = newJInt(500))
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
  var valid_579845 = query.getOrDefault("filter")
  valid_579845 = validateParameter(valid_579845, JString, required = false,
                                 default = nil)
  if valid_579845 != nil:
    section.add "filter", valid_579845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579868: Call_ResourceviewsZoneOperationsList_579692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of operation resources contained within the specified zone.
  ## 
  let valid = call_579868.validator(path, query, header, formData, body)
  let scheme = call_579868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579868.url(scheme.get, call_579868.host, call_579868.base,
                         call_579868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579868, url, valid)

proc call*(call_579939: Call_ResourceviewsZoneOperationsList_579692; zone: string;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; key: string = "";
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## resourceviewsZoneOperationsList
  ## Retrieves the list of operation resources contained within the specified zone.
  ##   zone: string (required)
  ##       : Name of the zone scoping this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Name of the project scoping this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Filter expression for filtering listed resources.
  var path_579940 = newJObject()
  var query_579942 = newJObject()
  add(path_579940, "zone", newJString(zone))
  add(query_579942, "fields", newJString(fields))
  add(query_579942, "pageToken", newJString(pageToken))
  add(query_579942, "quotaUser", newJString(quotaUser))
  add(query_579942, "alt", newJString(alt))
  add(query_579942, "oauth_token", newJString(oauthToken))
  add(query_579942, "userIp", newJString(userIp))
  add(query_579942, "maxResults", newJInt(maxResults))
  add(query_579942, "key", newJString(key))
  add(path_579940, "project", newJString(project))
  add(query_579942, "prettyPrint", newJBool(prettyPrint))
  add(query_579942, "filter", newJString(filter))
  result = call_579939.call(path_579940, query_579942, nil, nil, nil)

var resourceviewsZoneOperationsList* = Call_ResourceviewsZoneOperationsList_579692(
    name: "resourceviewsZoneOperationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/operations",
    validator: validate_ResourceviewsZoneOperationsList_579693,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneOperationsList_579694, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneOperationsGet_579981 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneOperationsGet_579983(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneOperationsGet_579982(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified zone-specific operation resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Name of the zone scoping this request.
  ##   operation: JString (required)
  ##            : Name of the operation resource to return.
  ##   project: JString (required)
  ##          : Name of the project scoping this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_579984 = path.getOrDefault("zone")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "zone", valid_579984
  var valid_579985 = path.getOrDefault("operation")
  valid_579985 = validateParameter(valid_579985, JString, required = true,
                                 default = nil)
  if valid_579985 != nil:
    section.add "operation", valid_579985
  var valid_579986 = path.getOrDefault("project")
  valid_579986 = validateParameter(valid_579986, JString, required = true,
                                 default = nil)
  if valid_579986 != nil:
    section.add "project", valid_579986
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
  var valid_579987 = query.getOrDefault("fields")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "fields", valid_579987
  var valid_579988 = query.getOrDefault("quotaUser")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "quotaUser", valid_579988
  var valid_579989 = query.getOrDefault("alt")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = newJString("json"))
  if valid_579989 != nil:
    section.add "alt", valid_579989
  var valid_579990 = query.getOrDefault("oauth_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "oauth_token", valid_579990
  var valid_579991 = query.getOrDefault("userIp")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "userIp", valid_579991
  var valid_579992 = query.getOrDefault("key")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "key", valid_579992
  var valid_579993 = query.getOrDefault("prettyPrint")
  valid_579993 = validateParameter(valid_579993, JBool, required = false,
                                 default = newJBool(true))
  if valid_579993 != nil:
    section.add "prettyPrint", valid_579993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579994: Call_ResourceviewsZoneOperationsGet_579981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified zone-specific operation resource.
  ## 
  let valid = call_579994.validator(path, query, header, formData, body)
  let scheme = call_579994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579994.url(scheme.get, call_579994.host, call_579994.base,
                         call_579994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579994, url, valid)

proc call*(call_579995: Call_ResourceviewsZoneOperationsGet_579981; zone: string;
          operation: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneOperationsGet
  ## Retrieves the specified zone-specific operation resource.
  ##   zone: string (required)
  ##       : Name of the zone scoping this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   operation: string (required)
  ##            : Name of the operation resource to return.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Name of the project scoping this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579996 = newJObject()
  var query_579997 = newJObject()
  add(path_579996, "zone", newJString(zone))
  add(query_579997, "fields", newJString(fields))
  add(query_579997, "quotaUser", newJString(quotaUser))
  add(query_579997, "alt", newJString(alt))
  add(path_579996, "operation", newJString(operation))
  add(query_579997, "oauth_token", newJString(oauthToken))
  add(query_579997, "userIp", newJString(userIp))
  add(query_579997, "key", newJString(key))
  add(path_579996, "project", newJString(project))
  add(query_579997, "prettyPrint", newJBool(prettyPrint))
  result = call_579995.call(path_579996, query_579997, nil, nil, nil)

var resourceviewsZoneOperationsGet* = Call_ResourceviewsZoneOperationsGet_579981(
    name: "resourceviewsZoneOperationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/operations/{operation}",
    validator: validate_ResourceviewsZoneOperationsGet_579982,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneOperationsGet_579983, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsInsert_580016 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsInsert_580018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsInsert_580017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580019 = path.getOrDefault("zone")
  valid_580019 = validateParameter(valid_580019, JString, required = true,
                                 default = nil)
  if valid_580019 != nil:
    section.add "zone", valid_580019
  var valid_580020 = path.getOrDefault("project")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "project", valid_580020
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580029: Call_ResourceviewsZoneViewsInsert_580016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource view.
  ## 
  let valid = call_580029.validator(path, query, header, formData, body)
  let scheme = call_580029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580029.url(scheme.get, call_580029.host, call_580029.base,
                         call_580029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580029, url, valid)

proc call*(call_580030: Call_ResourceviewsZoneViewsInsert_580016; zone: string;
          project: string; fields: string = ""; quotaUser: string = "";
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
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580031 = newJObject()
  var query_580032 = newJObject()
  var body_580033 = newJObject()
  add(path_580031, "zone", newJString(zone))
  add(query_580032, "fields", newJString(fields))
  add(query_580032, "quotaUser", newJString(quotaUser))
  add(query_580032, "alt", newJString(alt))
  add(query_580032, "oauth_token", newJString(oauthToken))
  add(query_580032, "userIp", newJString(userIp))
  add(query_580032, "key", newJString(key))
  add(path_580031, "project", newJString(project))
  if body != nil:
    body_580033 = body
  add(query_580032, "prettyPrint", newJBool(prettyPrint))
  result = call_580030.call(path_580031, query_580032, nil, nil, body_580033)

var resourceviewsZoneViewsInsert* = Call_ResourceviewsZoneViewsInsert_580016(
    name: "resourceviewsZoneViewsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/resourceViews",
    validator: validate_ResourceviewsZoneViewsInsert_580017,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsInsert_580018, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsList_579998 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsList_580000(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsList_579999(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List resource views.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580001 = path.getOrDefault("zone")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = nil)
  if valid_580001 != nil:
    section.add "zone", valid_580001
  var valid_580002 = path.getOrDefault("project")
  valid_580002 = validateParameter(valid_580002, JString, required = true,
                                 default = nil)
  if valid_580002 != nil:
    section.add "project", valid_580002
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
  var valid_580003 = query.getOrDefault("fields")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "fields", valid_580003
  var valid_580004 = query.getOrDefault("pageToken")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "pageToken", valid_580004
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
  var valid_580009 = query.getOrDefault("maxResults")
  valid_580009 = validateParameter(valid_580009, JInt, required = false,
                                 default = newJInt(5000))
  if valid_580009 != nil:
    section.add "maxResults", valid_580009
  var valid_580010 = query.getOrDefault("key")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "key", valid_580010
  var valid_580011 = query.getOrDefault("prettyPrint")
  valid_580011 = validateParameter(valid_580011, JBool, required = false,
                                 default = newJBool(true))
  if valid_580011 != nil:
    section.add "prettyPrint", valid_580011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580012: Call_ResourceviewsZoneViewsList_579998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List resource views.
  ## 
  let valid = call_580012.validator(path, query, header, formData, body)
  let scheme = call_580012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580012.url(scheme.get, call_580012.host, call_580012.base,
                         call_580012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580012, url, valid)

proc call*(call_580013: Call_ResourceviewsZoneViewsList_579998; zone: string;
          project: string; fields: string = ""; pageToken: string = "";
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
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580014 = newJObject()
  var query_580015 = newJObject()
  add(path_580014, "zone", newJString(zone))
  add(query_580015, "fields", newJString(fields))
  add(query_580015, "pageToken", newJString(pageToken))
  add(query_580015, "quotaUser", newJString(quotaUser))
  add(query_580015, "alt", newJString(alt))
  add(query_580015, "oauth_token", newJString(oauthToken))
  add(query_580015, "userIp", newJString(userIp))
  add(query_580015, "maxResults", newJInt(maxResults))
  add(query_580015, "key", newJString(key))
  add(path_580014, "project", newJString(project))
  add(query_580015, "prettyPrint", newJBool(prettyPrint))
  result = call_580013.call(path_580014, query_580015, nil, nil, nil)

var resourceviewsZoneViewsList* = Call_ResourceviewsZoneViewsList_579998(
    name: "resourceviewsZoneViewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/resourceViews",
    validator: validate_ResourceviewsZoneViewsList_579999,
    base: "/resourceviews/v1beta2/projects", url: url_ResourceviewsZoneViewsList_580000,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsGet_580034 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsGet_580036(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsGet_580035(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the information of a zonal resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580037 = path.getOrDefault("zone")
  valid_580037 = validateParameter(valid_580037, JString, required = true,
                                 default = nil)
  if valid_580037 != nil:
    section.add "zone", valid_580037
  var valid_580038 = path.getOrDefault("project")
  valid_580038 = validateParameter(valid_580038, JString, required = true,
                                 default = nil)
  if valid_580038 != nil:
    section.add "project", valid_580038
  var valid_580039 = path.getOrDefault("resourceView")
  valid_580039 = validateParameter(valid_580039, JString, required = true,
                                 default = nil)
  if valid_580039 != nil:
    section.add "resourceView", valid_580039
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
  var valid_580040 = query.getOrDefault("fields")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "fields", valid_580040
  var valid_580041 = query.getOrDefault("quotaUser")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "quotaUser", valid_580041
  var valid_580042 = query.getOrDefault("alt")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("json"))
  if valid_580042 != nil:
    section.add "alt", valid_580042
  var valid_580043 = query.getOrDefault("oauth_token")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "oauth_token", valid_580043
  var valid_580044 = query.getOrDefault("userIp")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "userIp", valid_580044
  var valid_580045 = query.getOrDefault("key")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "key", valid_580045
  var valid_580046 = query.getOrDefault("prettyPrint")
  valid_580046 = validateParameter(valid_580046, JBool, required = false,
                                 default = newJBool(true))
  if valid_580046 != nil:
    section.add "prettyPrint", valid_580046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580047: Call_ResourceviewsZoneViewsGet_580034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information of a zonal resource view.
  ## 
  let valid = call_580047.validator(path, query, header, formData, body)
  let scheme = call_580047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580047.url(scheme.get, call_580047.host, call_580047.base,
                         call_580047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580047, url, valid)

proc call*(call_580048: Call_ResourceviewsZoneViewsGet_580034; zone: string;
          project: string; resourceView: string; fields: string = "";
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
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_580049 = newJObject()
  var query_580050 = newJObject()
  add(path_580049, "zone", newJString(zone))
  add(query_580050, "fields", newJString(fields))
  add(query_580050, "quotaUser", newJString(quotaUser))
  add(query_580050, "alt", newJString(alt))
  add(query_580050, "oauth_token", newJString(oauthToken))
  add(query_580050, "userIp", newJString(userIp))
  add(query_580050, "key", newJString(key))
  add(path_580049, "project", newJString(project))
  add(query_580050, "prettyPrint", newJBool(prettyPrint))
  add(path_580049, "resourceView", newJString(resourceView))
  result = call_580048.call(path_580049, query_580050, nil, nil, nil)

var resourceviewsZoneViewsGet* = Call_ResourceviewsZoneViewsGet_580034(
    name: "resourceviewsZoneViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/resourceViews/{resourceView}",
    validator: validate_ResourceviewsZoneViewsGet_580035,
    base: "/resourceviews/v1beta2/projects", url: url_ResourceviewsZoneViewsGet_580036,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsDelete_580051 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsDelete_580053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsDelete_580052(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580054 = path.getOrDefault("zone")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "zone", valid_580054
  var valid_580055 = path.getOrDefault("project")
  valid_580055 = validateParameter(valid_580055, JString, required = true,
                                 default = nil)
  if valid_580055 != nil:
    section.add "project", valid_580055
  var valid_580056 = path.getOrDefault("resourceView")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "resourceView", valid_580056
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
  if body != nil:
    result.add "body", body

proc call*(call_580064: Call_ResourceviewsZoneViewsDelete_580051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a resource view.
  ## 
  let valid = call_580064.validator(path, query, header, formData, body)
  let scheme = call_580064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580064.url(scheme.get, call_580064.host, call_580064.base,
                         call_580064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580064, url, valid)

proc call*(call_580065: Call_ResourceviewsZoneViewsDelete_580051; zone: string;
          project: string; resourceView: string; fields: string = "";
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
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_580066 = newJObject()
  var query_580067 = newJObject()
  add(path_580066, "zone", newJString(zone))
  add(query_580067, "fields", newJString(fields))
  add(query_580067, "quotaUser", newJString(quotaUser))
  add(query_580067, "alt", newJString(alt))
  add(query_580067, "oauth_token", newJString(oauthToken))
  add(query_580067, "userIp", newJString(userIp))
  add(query_580067, "key", newJString(key))
  add(path_580066, "project", newJString(project))
  add(query_580067, "prettyPrint", newJBool(prettyPrint))
  add(path_580066, "resourceView", newJString(resourceView))
  result = call_580065.call(path_580066, query_580067, nil, nil, nil)

var resourceviewsZoneViewsDelete* = Call_ResourceviewsZoneViewsDelete_580051(
    name: "resourceviewsZoneViewsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/resourceViews/{resourceView}",
    validator: validate_ResourceviewsZoneViewsDelete_580052,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsDelete_580053, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsAddResources_580068 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsAddResources_580070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView"),
               (kind: ConstantSegment, value: "/addResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsAddResources_580069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add resources to the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580071 = path.getOrDefault("zone")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "zone", valid_580071
  var valid_580072 = path.getOrDefault("project")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "project", valid_580072
  var valid_580073 = path.getOrDefault("resourceView")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "resourceView", valid_580073
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
  var valid_580074 = query.getOrDefault("fields")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "fields", valid_580074
  var valid_580075 = query.getOrDefault("quotaUser")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "quotaUser", valid_580075
  var valid_580076 = query.getOrDefault("alt")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("json"))
  if valid_580076 != nil:
    section.add "alt", valid_580076
  var valid_580077 = query.getOrDefault("oauth_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "oauth_token", valid_580077
  var valid_580078 = query.getOrDefault("userIp")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "userIp", valid_580078
  var valid_580079 = query.getOrDefault("key")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "key", valid_580079
  var valid_580080 = query.getOrDefault("prettyPrint")
  valid_580080 = validateParameter(valid_580080, JBool, required = false,
                                 default = newJBool(true))
  if valid_580080 != nil:
    section.add "prettyPrint", valid_580080
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

proc call*(call_580082: Call_ResourceviewsZoneViewsAddResources_580068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add resources to the view.
  ## 
  let valid = call_580082.validator(path, query, header, formData, body)
  let scheme = call_580082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580082.url(scheme.get, call_580082.host, call_580082.base,
                         call_580082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580082, url, valid)

proc call*(call_580083: Call_ResourceviewsZoneViewsAddResources_580068;
          zone: string; project: string; resourceView: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsAddResources
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
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_580084 = newJObject()
  var query_580085 = newJObject()
  var body_580086 = newJObject()
  add(path_580084, "zone", newJString(zone))
  add(query_580085, "fields", newJString(fields))
  add(query_580085, "quotaUser", newJString(quotaUser))
  add(query_580085, "alt", newJString(alt))
  add(query_580085, "oauth_token", newJString(oauthToken))
  add(query_580085, "userIp", newJString(userIp))
  add(query_580085, "key", newJString(key))
  add(path_580084, "project", newJString(project))
  if body != nil:
    body_580086 = body
  add(query_580085, "prettyPrint", newJBool(prettyPrint))
  add(path_580084, "resourceView", newJString(resourceView))
  result = call_580083.call(path_580084, query_580085, nil, nil, body_580086)

var resourceviewsZoneViewsAddResources* = Call_ResourceviewsZoneViewsAddResources_580068(
    name: "resourceviewsZoneViewsAddResources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/resourceViews/{resourceView}/addResources",
    validator: validate_ResourceviewsZoneViewsAddResources_580069,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsAddResources_580070, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsGetService_580087 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsGetService_580089(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView"),
               (kind: ConstantSegment, value: "/getService")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsGetService_580088(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the service information of a resource view or a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580090 = path.getOrDefault("zone")
  valid_580090 = validateParameter(valid_580090, JString, required = true,
                                 default = nil)
  if valid_580090 != nil:
    section.add "zone", valid_580090
  var valid_580091 = path.getOrDefault("project")
  valid_580091 = validateParameter(valid_580091, JString, required = true,
                                 default = nil)
  if valid_580091 != nil:
    section.add "project", valid_580091
  var valid_580092 = path.getOrDefault("resourceView")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "resourceView", valid_580092
  result.add "path", section
  ## parameters in `query` object:
  ##   resourceName: JString
  ##               : The name of the resource if user wants to get the service information of the resource.
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
  var valid_580093 = query.getOrDefault("resourceName")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "resourceName", valid_580093
  var valid_580094 = query.getOrDefault("fields")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "fields", valid_580094
  var valid_580095 = query.getOrDefault("quotaUser")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "quotaUser", valid_580095
  var valid_580096 = query.getOrDefault("alt")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = newJString("json"))
  if valid_580096 != nil:
    section.add "alt", valid_580096
  var valid_580097 = query.getOrDefault("oauth_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "oauth_token", valid_580097
  var valid_580098 = query.getOrDefault("userIp")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "userIp", valid_580098
  var valid_580099 = query.getOrDefault("key")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "key", valid_580099
  var valid_580100 = query.getOrDefault("prettyPrint")
  valid_580100 = validateParameter(valid_580100, JBool, required = false,
                                 default = newJBool(true))
  if valid_580100 != nil:
    section.add "prettyPrint", valid_580100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580101: Call_ResourceviewsZoneViewsGetService_580087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the service information of a resource view or a resource.
  ## 
  let valid = call_580101.validator(path, query, header, formData, body)
  let scheme = call_580101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580101.url(scheme.get, call_580101.host, call_580101.base,
                         call_580101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580101, url, valid)

proc call*(call_580102: Call_ResourceviewsZoneViewsGetService_580087; zone: string;
          project: string; resourceView: string; resourceName: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsGetService
  ## Get the service information of a resource view or a resource.
  ##   resourceName: string
  ##               : The name of the resource if user wants to get the service information of the resource.
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
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_580103 = newJObject()
  var query_580104 = newJObject()
  add(query_580104, "resourceName", newJString(resourceName))
  add(path_580103, "zone", newJString(zone))
  add(query_580104, "fields", newJString(fields))
  add(query_580104, "quotaUser", newJString(quotaUser))
  add(query_580104, "alt", newJString(alt))
  add(query_580104, "oauth_token", newJString(oauthToken))
  add(query_580104, "userIp", newJString(userIp))
  add(query_580104, "key", newJString(key))
  add(path_580103, "project", newJString(project))
  add(query_580104, "prettyPrint", newJBool(prettyPrint))
  add(path_580103, "resourceView", newJString(resourceView))
  result = call_580102.call(path_580103, query_580104, nil, nil, nil)

var resourceviewsZoneViewsGetService* = Call_ResourceviewsZoneViewsGetService_580087(
    name: "resourceviewsZoneViewsGetService", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/resourceViews/{resourceView}/getService",
    validator: validate_ResourceviewsZoneViewsGetService_580088,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsGetService_580089, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsRemoveResources_580105 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsRemoveResources_580107(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView"),
               (kind: ConstantSegment, value: "/removeResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsRemoveResources_580106(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove resources from the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580108 = path.getOrDefault("zone")
  valid_580108 = validateParameter(valid_580108, JString, required = true,
                                 default = nil)
  if valid_580108 != nil:
    section.add "zone", valid_580108
  var valid_580109 = path.getOrDefault("project")
  valid_580109 = validateParameter(valid_580109, JString, required = true,
                                 default = nil)
  if valid_580109 != nil:
    section.add "project", valid_580109
  var valid_580110 = path.getOrDefault("resourceView")
  valid_580110 = validateParameter(valid_580110, JString, required = true,
                                 default = nil)
  if valid_580110 != nil:
    section.add "resourceView", valid_580110
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
  var valid_580111 = query.getOrDefault("fields")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "fields", valid_580111
  var valid_580112 = query.getOrDefault("quotaUser")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "quotaUser", valid_580112
  var valid_580113 = query.getOrDefault("alt")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("json"))
  if valid_580113 != nil:
    section.add "alt", valid_580113
  var valid_580114 = query.getOrDefault("oauth_token")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "oauth_token", valid_580114
  var valid_580115 = query.getOrDefault("userIp")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "userIp", valid_580115
  var valid_580116 = query.getOrDefault("key")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "key", valid_580116
  var valid_580117 = query.getOrDefault("prettyPrint")
  valid_580117 = validateParameter(valid_580117, JBool, required = false,
                                 default = newJBool(true))
  if valid_580117 != nil:
    section.add "prettyPrint", valid_580117
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

proc call*(call_580119: Call_ResourceviewsZoneViewsRemoveResources_580105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove resources from the view.
  ## 
  let valid = call_580119.validator(path, query, header, formData, body)
  let scheme = call_580119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580119.url(scheme.get, call_580119.host, call_580119.base,
                         call_580119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580119, url, valid)

proc call*(call_580120: Call_ResourceviewsZoneViewsRemoveResources_580105;
          zone: string; project: string; resourceView: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsRemoveResources
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
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_580121 = newJObject()
  var query_580122 = newJObject()
  var body_580123 = newJObject()
  add(path_580121, "zone", newJString(zone))
  add(query_580122, "fields", newJString(fields))
  add(query_580122, "quotaUser", newJString(quotaUser))
  add(query_580122, "alt", newJString(alt))
  add(query_580122, "oauth_token", newJString(oauthToken))
  add(query_580122, "userIp", newJString(userIp))
  add(query_580122, "key", newJString(key))
  add(path_580121, "project", newJString(project))
  if body != nil:
    body_580123 = body
  add(query_580122, "prettyPrint", newJBool(prettyPrint))
  add(path_580121, "resourceView", newJString(resourceView))
  result = call_580120.call(path_580121, query_580122, nil, nil, body_580123)

var resourceviewsZoneViewsRemoveResources* = Call_ResourceviewsZoneViewsRemoveResources_580105(
    name: "resourceviewsZoneViewsRemoveResources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/resourceViews/{resourceView}/removeResources",
    validator: validate_ResourceviewsZoneViewsRemoveResources_580106,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsRemoveResources_580107, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsListResources_580124 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsListResources_580126(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsListResources_580125(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the resources of the resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580127 = path.getOrDefault("zone")
  valid_580127 = validateParameter(valid_580127, JString, required = true,
                                 default = nil)
  if valid_580127 != nil:
    section.add "zone", valid_580127
  var valid_580128 = path.getOrDefault("project")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "project", valid_580128
  var valid_580129 = path.getOrDefault("resourceView")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "resourceView", valid_580129
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
  ##   serviceName: JString
  ##              : The service name to return in the response. It is optional and if it is not set, all the service end points will be returned.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   listState: JString
  ##            : The state of the instance to list. By default, it lists all instances.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   format: JString
  ##         : The requested format of the return value. It can be URL or URL_PORT. A JSON object will be included in the response based on the format. The default format is NONE, which results in no JSON in the response.
  section = newJObject()
  var valid_580130 = query.getOrDefault("fields")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "fields", valid_580130
  var valid_580131 = query.getOrDefault("pageToken")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "pageToken", valid_580131
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
  var valid_580134 = query.getOrDefault("serviceName")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "serviceName", valid_580134
  var valid_580135 = query.getOrDefault("oauth_token")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "oauth_token", valid_580135
  var valid_580136 = query.getOrDefault("userIp")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "userIp", valid_580136
  var valid_580137 = query.getOrDefault("maxResults")
  valid_580137 = validateParameter(valid_580137, JInt, required = false,
                                 default = newJInt(5000))
  if valid_580137 != nil:
    section.add "maxResults", valid_580137
  var valid_580138 = query.getOrDefault("listState")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = newJString("ALL"))
  if valid_580138 != nil:
    section.add "listState", valid_580138
  var valid_580139 = query.getOrDefault("key")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "key", valid_580139
  var valid_580140 = query.getOrDefault("prettyPrint")
  valid_580140 = validateParameter(valid_580140, JBool, required = false,
                                 default = newJBool(true))
  if valid_580140 != nil:
    section.add "prettyPrint", valid_580140
  var valid_580141 = query.getOrDefault("format")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = newJString("NONE"))
  if valid_580141 != nil:
    section.add "format", valid_580141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580142: Call_ResourceviewsZoneViewsListResources_580124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the resources of the resource view.
  ## 
  let valid = call_580142.validator(path, query, header, formData, body)
  let scheme = call_580142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580142.url(scheme.get, call_580142.host, call_580142.base,
                         call_580142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580142, url, valid)

proc call*(call_580143: Call_ResourceviewsZoneViewsListResources_580124;
          zone: string; project: string; resourceView: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          serviceName: string = ""; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5000; listState: string = "ALL"; key: string = "";
          prettyPrint: bool = true; format: string = "NONE"): Recallable =
  ## resourceviewsZoneViewsListResources
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
  ##   serviceName: string
  ##              : The service name to return in the response. It is optional and if it is not set, all the service end points will be returned.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   listState: string
  ##            : The state of the instance to list. By default, it lists all instances.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   format: string
  ##         : The requested format of the return value. It can be URL or URL_PORT. A JSON object will be included in the response based on the format. The default format is NONE, which results in no JSON in the response.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_580144 = newJObject()
  var query_580145 = newJObject()
  add(path_580144, "zone", newJString(zone))
  add(query_580145, "fields", newJString(fields))
  add(query_580145, "pageToken", newJString(pageToken))
  add(query_580145, "quotaUser", newJString(quotaUser))
  add(query_580145, "alt", newJString(alt))
  add(query_580145, "serviceName", newJString(serviceName))
  add(query_580145, "oauth_token", newJString(oauthToken))
  add(query_580145, "userIp", newJString(userIp))
  add(query_580145, "maxResults", newJInt(maxResults))
  add(query_580145, "listState", newJString(listState))
  add(query_580145, "key", newJString(key))
  add(path_580144, "project", newJString(project))
  add(query_580145, "prettyPrint", newJBool(prettyPrint))
  add(query_580145, "format", newJString(format))
  add(path_580144, "resourceView", newJString(resourceView))
  result = call_580143.call(path_580144, query_580145, nil, nil, nil)

var resourceviewsZoneViewsListResources* = Call_ResourceviewsZoneViewsListResources_580124(
    name: "resourceviewsZoneViewsListResources", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/resourceViews/{resourceView}/resources",
    validator: validate_ResourceviewsZoneViewsListResources_580125,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsListResources_580126, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsSetService_580146 = ref object of OpenApiRestCall_579424
proc url_ResourceviewsZoneViewsSetService_580148(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView"),
               (kind: ConstantSegment, value: "/setService")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsSetService_580147(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the service information of a resource view or a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_580149 = path.getOrDefault("zone")
  valid_580149 = validateParameter(valid_580149, JString, required = true,
                                 default = nil)
  if valid_580149 != nil:
    section.add "zone", valid_580149
  var valid_580150 = path.getOrDefault("project")
  valid_580150 = validateParameter(valid_580150, JString, required = true,
                                 default = nil)
  if valid_580150 != nil:
    section.add "project", valid_580150
  var valid_580151 = path.getOrDefault("resourceView")
  valid_580151 = validateParameter(valid_580151, JString, required = true,
                                 default = nil)
  if valid_580151 != nil:
    section.add "resourceView", valid_580151
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
  var valid_580152 = query.getOrDefault("fields")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "fields", valid_580152
  var valid_580153 = query.getOrDefault("quotaUser")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "quotaUser", valid_580153
  var valid_580154 = query.getOrDefault("alt")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = newJString("json"))
  if valid_580154 != nil:
    section.add "alt", valid_580154
  var valid_580155 = query.getOrDefault("oauth_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "oauth_token", valid_580155
  var valid_580156 = query.getOrDefault("userIp")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "userIp", valid_580156
  var valid_580157 = query.getOrDefault("key")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "key", valid_580157
  var valid_580158 = query.getOrDefault("prettyPrint")
  valid_580158 = validateParameter(valid_580158, JBool, required = false,
                                 default = newJBool(true))
  if valid_580158 != nil:
    section.add "prettyPrint", valid_580158
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

proc call*(call_580160: Call_ResourceviewsZoneViewsSetService_580146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the service information of a resource view or a resource.
  ## 
  let valid = call_580160.validator(path, query, header, formData, body)
  let scheme = call_580160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580160.url(scheme.get, call_580160.host, call_580160.base,
                         call_580160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580160, url, valid)

proc call*(call_580161: Call_ResourceviewsZoneViewsSetService_580146; zone: string;
          project: string; resourceView: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsSetService
  ## Update the service information of a resource view or a resource.
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
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_580162 = newJObject()
  var query_580163 = newJObject()
  var body_580164 = newJObject()
  add(path_580162, "zone", newJString(zone))
  add(query_580163, "fields", newJString(fields))
  add(query_580163, "quotaUser", newJString(quotaUser))
  add(query_580163, "alt", newJString(alt))
  add(query_580163, "oauth_token", newJString(oauthToken))
  add(query_580163, "userIp", newJString(userIp))
  add(query_580163, "key", newJString(key))
  add(path_580162, "project", newJString(project))
  if body != nil:
    body_580164 = body
  add(query_580163, "prettyPrint", newJBool(prettyPrint))
  add(path_580162, "resourceView", newJString(resourceView))
  result = call_580161.call(path_580162, query_580163, nil, nil, body_580164)

var resourceviewsZoneViewsSetService* = Call_ResourceviewsZoneViewsSetService_580146(
    name: "resourceviewsZoneViewsSetService", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/resourceViews/{resourceView}/setService",
    validator: validate_ResourceviewsZoneViewsSetService_580147,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsSetService_580148, schemes: {Scheme.Https})
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
