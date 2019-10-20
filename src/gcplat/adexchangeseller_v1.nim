
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Ad Exchange Seller
## version: v1
## termsOfService: (not provided)
## license: (not provided)
## 
## Accesses the inventory of Ad Exchange seller users and generates reports.
## 
## https://developers.google.com/ad-exchange/seller-rest/
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
  gcpServiceName = "adexchangeseller"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdexchangesellerAdclientsList_578625 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAdclientsList_578627(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerAdclientsList_578626(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad clients in this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad clients to include in the response, used for paging.
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("alt")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("json"))
  if valid_578755 != nil:
    section.add "alt", valid_578755
  var valid_578756 = query.getOrDefault("userIp")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "userIp", valid_578756
  var valid_578757 = query.getOrDefault("quotaUser")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "quotaUser", valid_578757
  var valid_578758 = query.getOrDefault("pageToken")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "pageToken", valid_578758
  var valid_578759 = query.getOrDefault("fields")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "fields", valid_578759
  var valid_578760 = query.getOrDefault("maxResults")
  valid_578760 = validateParameter(valid_578760, JInt, required = false, default = nil)
  if valid_578760 != nil:
    section.add "maxResults", valid_578760
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578783: Call_AdexchangesellerAdclientsList_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in this Ad Exchange account.
  ## 
  let valid = call_578783.validator(path, query, header, formData, body)
  let scheme = call_578783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578783.url(scheme.get, call_578783.host, call_578783.base,
                         call_578783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578783, url, valid)

proc call*(call_578854: Call_AdexchangesellerAdclientsList_578625;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerAdclientsList
  ## List all ad clients in this Ad Exchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  var query_578855 = newJObject()
  add(query_578855, "key", newJString(key))
  add(query_578855, "prettyPrint", newJBool(prettyPrint))
  add(query_578855, "oauth_token", newJString(oauthToken))
  add(query_578855, "alt", newJString(alt))
  add(query_578855, "userIp", newJString(userIp))
  add(query_578855, "quotaUser", newJString(quotaUser))
  add(query_578855, "pageToken", newJString(pageToken))
  add(query_578855, "fields", newJString(fields))
  add(query_578855, "maxResults", newJInt(maxResults))
  result = call_578854.call(nil, query_578855, nil, nil, nil)

var adexchangesellerAdclientsList* = Call_AdexchangesellerAdclientsList_578625(
    name: "adexchangesellerAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdexchangesellerAdclientsList_578626,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerAdclientsList_578627,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsList_578895 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAdunitsList_578897(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAdunitsList_578896(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified ad client for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list ad units.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578912 = path.getOrDefault("adClientId")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "adClientId", valid_578912
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  section = newJObject()
  var valid_578913 = query.getOrDefault("key")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "key", valid_578913
  var valid_578914 = query.getOrDefault("prettyPrint")
  valid_578914 = validateParameter(valid_578914, JBool, required = false,
                                 default = newJBool(true))
  if valid_578914 != nil:
    section.add "prettyPrint", valid_578914
  var valid_578915 = query.getOrDefault("oauth_token")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "oauth_token", valid_578915
  var valid_578916 = query.getOrDefault("alt")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = newJString("json"))
  if valid_578916 != nil:
    section.add "alt", valid_578916
  var valid_578917 = query.getOrDefault("userIp")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "userIp", valid_578917
  var valid_578918 = query.getOrDefault("quotaUser")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "quotaUser", valid_578918
  var valid_578919 = query.getOrDefault("pageToken")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "pageToken", valid_578919
  var valid_578920 = query.getOrDefault("includeInactive")
  valid_578920 = validateParameter(valid_578920, JBool, required = false, default = nil)
  if valid_578920 != nil:
    section.add "includeInactive", valid_578920
  var valid_578921 = query.getOrDefault("fields")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "fields", valid_578921
  var valid_578922 = query.getOrDefault("maxResults")
  valid_578922 = validateParameter(valid_578922, JInt, required = false, default = nil)
  if valid_578922 != nil:
    section.add "maxResults", valid_578922
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578923: Call_AdexchangesellerAdunitsList_578895; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_578923.validator(path, query, header, formData, body)
  let scheme = call_578923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578923.url(scheme.get, call_578923.host, call_578923.base,
                         call_578923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578923, url, valid)

proc call*(call_578924: Call_AdexchangesellerAdunitsList_578895;
          adClientId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; includeInactive: bool = false;
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerAdunitsList
  ## List all ad units in the specified ad client for this Ad Exchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client for which to list ad units.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  var path_578925 = newJObject()
  var query_578926 = newJObject()
  add(query_578926, "key", newJString(key))
  add(query_578926, "prettyPrint", newJBool(prettyPrint))
  add(query_578926, "oauth_token", newJString(oauthToken))
  add(query_578926, "alt", newJString(alt))
  add(query_578926, "userIp", newJString(userIp))
  add(query_578926, "quotaUser", newJString(quotaUser))
  add(query_578926, "pageToken", newJString(pageToken))
  add(path_578925, "adClientId", newJString(adClientId))
  add(query_578926, "includeInactive", newJBool(includeInactive))
  add(query_578926, "fields", newJString(fields))
  add(query_578926, "maxResults", newJInt(maxResults))
  result = call_578924.call(path_578925, query_578926, nil, nil, nil)

var adexchangesellerAdunitsList* = Call_AdexchangesellerAdunitsList_578895(
    name: "adexchangesellerAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/adunits",
    validator: validate_AdexchangesellerAdunitsList_578896,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerAdunitsList_578897,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsGet_578927 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAdunitsGet_578929(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAdunitsGet_578928(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578930 = path.getOrDefault("adClientId")
  valid_578930 = validateParameter(valid_578930, JString, required = true,
                                 default = nil)
  if valid_578930 != nil:
    section.add "adClientId", valid_578930
  var valid_578931 = path.getOrDefault("adUnitId")
  valid_578931 = validateParameter(valid_578931, JString, required = true,
                                 default = nil)
  if valid_578931 != nil:
    section.add "adUnitId", valid_578931
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578932 = query.getOrDefault("key")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "key", valid_578932
  var valid_578933 = query.getOrDefault("prettyPrint")
  valid_578933 = validateParameter(valid_578933, JBool, required = false,
                                 default = newJBool(true))
  if valid_578933 != nil:
    section.add "prettyPrint", valid_578933
  var valid_578934 = query.getOrDefault("oauth_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "oauth_token", valid_578934
  var valid_578935 = query.getOrDefault("alt")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = newJString("json"))
  if valid_578935 != nil:
    section.add "alt", valid_578935
  var valid_578936 = query.getOrDefault("userIp")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "userIp", valid_578936
  var valid_578937 = query.getOrDefault("quotaUser")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "quotaUser", valid_578937
  var valid_578938 = query.getOrDefault("fields")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "fields", valid_578938
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578939: Call_AdexchangesellerAdunitsGet_578927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  let valid = call_578939.validator(path, query, header, formData, body)
  let scheme = call_578939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578939.url(scheme.get, call_578939.host, call_578939.base,
                         call_578939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578939, url, valid)

proc call*(call_578940: Call_AdexchangesellerAdunitsGet_578927; adClientId: string;
          adUnitId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangesellerAdunitsGet
  ## Gets the specified ad unit in the specified ad client.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   adClientId: string (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578941 = newJObject()
  var query_578942 = newJObject()
  add(query_578942, "key", newJString(key))
  add(query_578942, "prettyPrint", newJBool(prettyPrint))
  add(query_578942, "oauth_token", newJString(oauthToken))
  add(query_578942, "alt", newJString(alt))
  add(query_578942, "userIp", newJString(userIp))
  add(query_578942, "quotaUser", newJString(quotaUser))
  add(path_578941, "adClientId", newJString(adClientId))
  add(path_578941, "adUnitId", newJString(adUnitId))
  add(query_578942, "fields", newJString(fields))
  result = call_578940.call(path_578941, query_578942, nil, nil, nil)

var adexchangesellerAdunitsGet* = Call_AdexchangesellerAdunitsGet_578927(
    name: "adexchangesellerAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdexchangesellerAdunitsGet_578928,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerAdunitsGet_578929,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsCustomchannelsList_578943 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAdunitsCustomchannelsList_578945(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId"),
               (kind: ConstantSegment, value: "/customchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAdunitsCustomchannelsList_578944(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client which contains the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit for which to list custom channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578946 = path.getOrDefault("adClientId")
  valid_578946 = validateParameter(valid_578946, JString, required = true,
                                 default = nil)
  if valid_578946 != nil:
    section.add "adClientId", valid_578946
  var valid_578947 = path.getOrDefault("adUnitId")
  valid_578947 = validateParameter(valid_578947, JString, required = true,
                                 default = nil)
  if valid_578947 != nil:
    section.add "adUnitId", valid_578947
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  section = newJObject()
  var valid_578948 = query.getOrDefault("key")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "key", valid_578948
  var valid_578949 = query.getOrDefault("prettyPrint")
  valid_578949 = validateParameter(valid_578949, JBool, required = false,
                                 default = newJBool(true))
  if valid_578949 != nil:
    section.add "prettyPrint", valid_578949
  var valid_578950 = query.getOrDefault("oauth_token")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "oauth_token", valid_578950
  var valid_578951 = query.getOrDefault("alt")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = newJString("json"))
  if valid_578951 != nil:
    section.add "alt", valid_578951
  var valid_578952 = query.getOrDefault("userIp")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "userIp", valid_578952
  var valid_578953 = query.getOrDefault("quotaUser")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "quotaUser", valid_578953
  var valid_578954 = query.getOrDefault("pageToken")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "pageToken", valid_578954
  var valid_578955 = query.getOrDefault("fields")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "fields", valid_578955
  var valid_578956 = query.getOrDefault("maxResults")
  valid_578956 = validateParameter(valid_578956, JInt, required = false, default = nil)
  if valid_578956 != nil:
    section.add "maxResults", valid_578956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578957: Call_AdexchangesellerAdunitsCustomchannelsList_578943;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_578957.validator(path, query, header, formData, body)
  let scheme = call_578957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578957.url(scheme.get, call_578957.host, call_578957.base,
                         call_578957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578957, url, valid)

proc call*(call_578958: Call_AdexchangesellerAdunitsCustomchannelsList_578943;
          adClientId: string; adUnitId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerAdunitsCustomchannelsList
  ## List all custom channels which the specified ad unit belongs to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client which contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit for which to list custom channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  var path_578959 = newJObject()
  var query_578960 = newJObject()
  add(query_578960, "key", newJString(key))
  add(query_578960, "prettyPrint", newJBool(prettyPrint))
  add(query_578960, "oauth_token", newJString(oauthToken))
  add(query_578960, "alt", newJString(alt))
  add(query_578960, "userIp", newJString(userIp))
  add(query_578960, "quotaUser", newJString(quotaUser))
  add(query_578960, "pageToken", newJString(pageToken))
  add(path_578959, "adClientId", newJString(adClientId))
  add(path_578959, "adUnitId", newJString(adUnitId))
  add(query_578960, "fields", newJString(fields))
  add(query_578960, "maxResults", newJInt(maxResults))
  result = call_578958.call(path_578959, query_578960, nil, nil, nil)

var adexchangesellerAdunitsCustomchannelsList* = Call_AdexchangesellerAdunitsCustomchannelsList_578943(
    name: "adexchangesellerAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdexchangesellerAdunitsCustomchannelsList_578944,
    base: "/adexchangeseller/v1",
    url: url_AdexchangesellerAdunitsCustomchannelsList_578945,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsList_578961 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerCustomchannelsList_578963(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerCustomchannelsList_578962(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list custom channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578964 = path.getOrDefault("adClientId")
  valid_578964 = validateParameter(valid_578964, JString, required = true,
                                 default = nil)
  if valid_578964 != nil:
    section.add "adClientId", valid_578964
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  section = newJObject()
  var valid_578965 = query.getOrDefault("key")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "key", valid_578965
  var valid_578966 = query.getOrDefault("prettyPrint")
  valid_578966 = validateParameter(valid_578966, JBool, required = false,
                                 default = newJBool(true))
  if valid_578966 != nil:
    section.add "prettyPrint", valid_578966
  var valid_578967 = query.getOrDefault("oauth_token")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "oauth_token", valid_578967
  var valid_578968 = query.getOrDefault("alt")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = newJString("json"))
  if valid_578968 != nil:
    section.add "alt", valid_578968
  var valid_578969 = query.getOrDefault("userIp")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "userIp", valid_578969
  var valid_578970 = query.getOrDefault("quotaUser")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "quotaUser", valid_578970
  var valid_578971 = query.getOrDefault("pageToken")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "pageToken", valid_578971
  var valid_578972 = query.getOrDefault("fields")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "fields", valid_578972
  var valid_578973 = query.getOrDefault("maxResults")
  valid_578973 = validateParameter(valid_578973, JInt, required = false, default = nil)
  if valid_578973 != nil:
    section.add "maxResults", valid_578973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578974: Call_AdexchangesellerCustomchannelsList_578961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_578974.validator(path, query, header, formData, body)
  let scheme = call_578974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578974.url(scheme.get, call_578974.host, call_578974.base,
                         call_578974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578974, url, valid)

proc call*(call_578975: Call_AdexchangesellerCustomchannelsList_578961;
          adClientId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## adexchangesellerCustomchannelsList
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client for which to list custom channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  var path_578976 = newJObject()
  var query_578977 = newJObject()
  add(query_578977, "key", newJString(key))
  add(query_578977, "prettyPrint", newJBool(prettyPrint))
  add(query_578977, "oauth_token", newJString(oauthToken))
  add(query_578977, "alt", newJString(alt))
  add(query_578977, "userIp", newJString(userIp))
  add(query_578977, "quotaUser", newJString(quotaUser))
  add(query_578977, "pageToken", newJString(pageToken))
  add(path_578976, "adClientId", newJString(adClientId))
  add(query_578977, "fields", newJString(fields))
  add(query_578977, "maxResults", newJInt(maxResults))
  result = call_578975.call(path_578976, query_578977, nil, nil, nil)

var adexchangesellerCustomchannelsList* = Call_AdexchangesellerCustomchannelsList_578961(
    name: "adexchangesellerCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdexchangesellerCustomchannelsList_578962,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerCustomchannelsList_578963,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsGet_578978 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerCustomchannelsGet_578980(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "customChannelId" in path, "`customChannelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels/"),
               (kind: VariableSegment, value: "customChannelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerCustomchannelsGet_578979(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified custom channel from the specified ad client.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  ##   customChannelId: JString (required)
  ##                  : Custom channel to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578981 = path.getOrDefault("adClientId")
  valid_578981 = validateParameter(valid_578981, JString, required = true,
                                 default = nil)
  if valid_578981 != nil:
    section.add "adClientId", valid_578981
  var valid_578982 = path.getOrDefault("customChannelId")
  valid_578982 = validateParameter(valid_578982, JString, required = true,
                                 default = nil)
  if valid_578982 != nil:
    section.add "customChannelId", valid_578982
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578983 = query.getOrDefault("key")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "key", valid_578983
  var valid_578984 = query.getOrDefault("prettyPrint")
  valid_578984 = validateParameter(valid_578984, JBool, required = false,
                                 default = newJBool(true))
  if valid_578984 != nil:
    section.add "prettyPrint", valid_578984
  var valid_578985 = query.getOrDefault("oauth_token")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "oauth_token", valid_578985
  var valid_578986 = query.getOrDefault("alt")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = newJString("json"))
  if valid_578986 != nil:
    section.add "alt", valid_578986
  var valid_578987 = query.getOrDefault("userIp")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "userIp", valid_578987
  var valid_578988 = query.getOrDefault("quotaUser")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "quotaUser", valid_578988
  var valid_578989 = query.getOrDefault("fields")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "fields", valid_578989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578990: Call_AdexchangesellerCustomchannelsGet_578978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_578990.validator(path, query, header, formData, body)
  let scheme = call_578990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578990.url(scheme.get, call_578990.host, call_578990.base,
                         call_578990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578990, url, valid)

proc call*(call_578991: Call_AdexchangesellerCustomchannelsGet_578978;
          adClientId: string; customChannelId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangesellerCustomchannelsGet
  ## Get the specified custom channel from the specified ad client.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   customChannelId: string (required)
  ##                  : Custom channel to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578992 = newJObject()
  var query_578993 = newJObject()
  add(query_578993, "key", newJString(key))
  add(query_578993, "prettyPrint", newJBool(prettyPrint))
  add(query_578993, "oauth_token", newJString(oauthToken))
  add(query_578993, "alt", newJString(alt))
  add(query_578993, "userIp", newJString(userIp))
  add(query_578993, "quotaUser", newJString(quotaUser))
  add(path_578992, "adClientId", newJString(adClientId))
  add(path_578992, "customChannelId", newJString(customChannelId))
  add(query_578993, "fields", newJString(fields))
  result = call_578991.call(path_578992, query_578993, nil, nil, nil)

var adexchangesellerCustomchannelsGet* = Call_AdexchangesellerCustomchannelsGet_578978(
    name: "adexchangesellerCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdexchangesellerCustomchannelsGet_578979,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerCustomchannelsGet_578980,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsAdunitsList_578994 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerCustomchannelsAdunitsList_578996(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "customChannelId" in path, "`customChannelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels/"),
               (kind: VariableSegment, value: "customChannelId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerCustomchannelsAdunitsList_578995(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified custom channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  ##   customChannelId: JString (required)
  ##                  : Custom channel for which to list ad units.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578997 = path.getOrDefault("adClientId")
  valid_578997 = validateParameter(valid_578997, JString, required = true,
                                 default = nil)
  if valid_578997 != nil:
    section.add "adClientId", valid_578997
  var valid_578998 = path.getOrDefault("customChannelId")
  valid_578998 = validateParameter(valid_578998, JString, required = true,
                                 default = nil)
  if valid_578998 != nil:
    section.add "customChannelId", valid_578998
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  section = newJObject()
  var valid_578999 = query.getOrDefault("key")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "key", valid_578999
  var valid_579000 = query.getOrDefault("prettyPrint")
  valid_579000 = validateParameter(valid_579000, JBool, required = false,
                                 default = newJBool(true))
  if valid_579000 != nil:
    section.add "prettyPrint", valid_579000
  var valid_579001 = query.getOrDefault("oauth_token")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "oauth_token", valid_579001
  var valid_579002 = query.getOrDefault("alt")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = newJString("json"))
  if valid_579002 != nil:
    section.add "alt", valid_579002
  var valid_579003 = query.getOrDefault("userIp")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "userIp", valid_579003
  var valid_579004 = query.getOrDefault("quotaUser")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "quotaUser", valid_579004
  var valid_579005 = query.getOrDefault("pageToken")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "pageToken", valid_579005
  var valid_579006 = query.getOrDefault("includeInactive")
  valid_579006 = validateParameter(valid_579006, JBool, required = false, default = nil)
  if valid_579006 != nil:
    section.add "includeInactive", valid_579006
  var valid_579007 = query.getOrDefault("fields")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "fields", valid_579007
  var valid_579008 = query.getOrDefault("maxResults")
  valid_579008 = validateParameter(valid_579008, JInt, required = false, default = nil)
  if valid_579008 != nil:
    section.add "maxResults", valid_579008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579009: Call_AdexchangesellerCustomchannelsAdunitsList_578994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_579009.validator(path, query, header, formData, body)
  let scheme = call_579009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579009.url(scheme.get, call_579009.host, call_579009.base,
                         call_579009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579009, url, valid)

proc call*(call_579010: Call_AdexchangesellerCustomchannelsAdunitsList_578994;
          adClientId: string; customChannelId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          includeInactive: bool = false; fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerCustomchannelsAdunitsList
  ## List all ad units in the specified custom channel.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   customChannelId: string (required)
  ##                  : Custom channel for which to list ad units.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  var path_579011 = newJObject()
  var query_579012 = newJObject()
  add(query_579012, "key", newJString(key))
  add(query_579012, "prettyPrint", newJBool(prettyPrint))
  add(query_579012, "oauth_token", newJString(oauthToken))
  add(query_579012, "alt", newJString(alt))
  add(query_579012, "userIp", newJString(userIp))
  add(query_579012, "quotaUser", newJString(quotaUser))
  add(query_579012, "pageToken", newJString(pageToken))
  add(path_579011, "adClientId", newJString(adClientId))
  add(path_579011, "customChannelId", newJString(customChannelId))
  add(query_579012, "includeInactive", newJBool(includeInactive))
  add(query_579012, "fields", newJString(fields))
  add(query_579012, "maxResults", newJInt(maxResults))
  result = call_579010.call(path_579011, query_579012, nil, nil, nil)

var adexchangesellerCustomchannelsAdunitsList* = Call_AdexchangesellerCustomchannelsAdunitsList_578994(
    name: "adexchangesellerCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdexchangesellerCustomchannelsAdunitsList_578995,
    base: "/adexchangeseller/v1",
    url: url_AdexchangesellerCustomchannelsAdunitsList_578996,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerUrlchannelsList_579013 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerUrlchannelsList_579015(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/urlchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerUrlchannelsList_579014(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list URL channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579016 = path.getOrDefault("adClientId")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "adClientId", valid_579016
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of URL channels to include in the response, used for paging.
  section = newJObject()
  var valid_579017 = query.getOrDefault("key")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "key", valid_579017
  var valid_579018 = query.getOrDefault("prettyPrint")
  valid_579018 = validateParameter(valid_579018, JBool, required = false,
                                 default = newJBool(true))
  if valid_579018 != nil:
    section.add "prettyPrint", valid_579018
  var valid_579019 = query.getOrDefault("oauth_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "oauth_token", valid_579019
  var valid_579020 = query.getOrDefault("alt")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = newJString("json"))
  if valid_579020 != nil:
    section.add "alt", valid_579020
  var valid_579021 = query.getOrDefault("userIp")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "userIp", valid_579021
  var valid_579022 = query.getOrDefault("quotaUser")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "quotaUser", valid_579022
  var valid_579023 = query.getOrDefault("pageToken")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "pageToken", valid_579023
  var valid_579024 = query.getOrDefault("fields")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "fields", valid_579024
  var valid_579025 = query.getOrDefault("maxResults")
  valid_579025 = validateParameter(valid_579025, JInt, required = false, default = nil)
  if valid_579025 != nil:
    section.add "maxResults", valid_579025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579026: Call_AdexchangesellerUrlchannelsList_579013;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_579026.validator(path, query, header, formData, body)
  let scheme = call_579026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579026.url(scheme.get, call_579026.host, call_579026.base,
                         call_579026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579026, url, valid)

proc call*(call_579027: Call_AdexchangesellerUrlchannelsList_579013;
          adClientId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## adexchangesellerUrlchannelsList
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client for which to list URL channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of URL channels to include in the response, used for paging.
  var path_579028 = newJObject()
  var query_579029 = newJObject()
  add(query_579029, "key", newJString(key))
  add(query_579029, "prettyPrint", newJBool(prettyPrint))
  add(query_579029, "oauth_token", newJString(oauthToken))
  add(query_579029, "alt", newJString(alt))
  add(query_579029, "userIp", newJString(userIp))
  add(query_579029, "quotaUser", newJString(quotaUser))
  add(query_579029, "pageToken", newJString(pageToken))
  add(path_579028, "adClientId", newJString(adClientId))
  add(query_579029, "fields", newJString(fields))
  add(query_579029, "maxResults", newJInt(maxResults))
  result = call_579027.call(path_579028, query_579029, nil, nil, nil)

var adexchangesellerUrlchannelsList* = Call_AdexchangesellerUrlchannelsList_579013(
    name: "adexchangesellerUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdexchangesellerUrlchannelsList_579014,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerUrlchannelsList_579015,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsGenerate_579030 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerReportsGenerate_579032(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerReportsGenerate_579031(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: JString (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: JString (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  section = newJObject()
  var valid_579033 = query.getOrDefault("key")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "key", valid_579033
  var valid_579034 = query.getOrDefault("prettyPrint")
  valid_579034 = validateParameter(valid_579034, JBool, required = false,
                                 default = newJBool(true))
  if valid_579034 != nil:
    section.add "prettyPrint", valid_579034
  var valid_579035 = query.getOrDefault("oauth_token")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "oauth_token", valid_579035
  var valid_579036 = query.getOrDefault("locale")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "locale", valid_579036
  var valid_579037 = query.getOrDefault("alt")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = newJString("json"))
  if valid_579037 != nil:
    section.add "alt", valid_579037
  var valid_579038 = query.getOrDefault("userIp")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "userIp", valid_579038
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_579039 = query.getOrDefault("endDate")
  valid_579039 = validateParameter(valid_579039, JString, required = true,
                                 default = nil)
  if valid_579039 != nil:
    section.add "endDate", valid_579039
  var valid_579040 = query.getOrDefault("quotaUser")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "quotaUser", valid_579040
  var valid_579041 = query.getOrDefault("startIndex")
  valid_579041 = validateParameter(valid_579041, JInt, required = false, default = nil)
  if valid_579041 != nil:
    section.add "startIndex", valid_579041
  var valid_579042 = query.getOrDefault("filter")
  valid_579042 = validateParameter(valid_579042, JArray, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "filter", valid_579042
  var valid_579043 = query.getOrDefault("dimension")
  valid_579043 = validateParameter(valid_579043, JArray, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "dimension", valid_579043
  var valid_579044 = query.getOrDefault("metric")
  valid_579044 = validateParameter(valid_579044, JArray, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "metric", valid_579044
  var valid_579045 = query.getOrDefault("fields")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "fields", valid_579045
  var valid_579046 = query.getOrDefault("startDate")
  valid_579046 = validateParameter(valid_579046, JString, required = true,
                                 default = nil)
  if valid_579046 != nil:
    section.add "startDate", valid_579046
  var valid_579047 = query.getOrDefault("maxResults")
  valid_579047 = validateParameter(valid_579047, JInt, required = false, default = nil)
  if valid_579047 != nil:
    section.add "maxResults", valid_579047
  var valid_579048 = query.getOrDefault("sort")
  valid_579048 = validateParameter(valid_579048, JArray, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "sort", valid_579048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579049: Call_AdexchangesellerReportsGenerate_579030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_579049.validator(path, query, header, formData, body)
  let scheme = call_579049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579049.url(scheme.get, call_579049.host, call_579049.base,
                         call_579049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579049, url, valid)

proc call*(call_579050: Call_AdexchangesellerReportsGenerate_579030;
          endDate: string; startDate: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; filter: JsonNode = nil; dimension: JsonNode = nil;
          metric: JsonNode = nil; fields: string = ""; maxResults: int = 0;
          sort: JsonNode = nil): Recallable =
  ## adexchangesellerReportsGenerate
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: string (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  var query_579051 = newJObject()
  add(query_579051, "key", newJString(key))
  add(query_579051, "prettyPrint", newJBool(prettyPrint))
  add(query_579051, "oauth_token", newJString(oauthToken))
  add(query_579051, "locale", newJString(locale))
  add(query_579051, "alt", newJString(alt))
  add(query_579051, "userIp", newJString(userIp))
  add(query_579051, "endDate", newJString(endDate))
  add(query_579051, "quotaUser", newJString(quotaUser))
  add(query_579051, "startIndex", newJInt(startIndex))
  if filter != nil:
    query_579051.add "filter", filter
  if dimension != nil:
    query_579051.add "dimension", dimension
  if metric != nil:
    query_579051.add "metric", metric
  add(query_579051, "fields", newJString(fields))
  add(query_579051, "startDate", newJString(startDate))
  add(query_579051, "maxResults", newJInt(maxResults))
  if sort != nil:
    query_579051.add "sort", sort
  result = call_579050.call(nil, query_579051, nil, nil, nil)

var adexchangesellerReportsGenerate* = Call_AdexchangesellerReportsGenerate_579030(
    name: "adexchangesellerReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdexchangesellerReportsGenerate_579031,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerReportsGenerate_579032,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsSavedList_579052 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerReportsSavedList_579054(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerReportsSavedList_579053(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved reports in this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of saved reports to include in the response, used for paging.
  section = newJObject()
  var valid_579055 = query.getOrDefault("key")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "key", valid_579055
  var valid_579056 = query.getOrDefault("prettyPrint")
  valid_579056 = validateParameter(valid_579056, JBool, required = false,
                                 default = newJBool(true))
  if valid_579056 != nil:
    section.add "prettyPrint", valid_579056
  var valid_579057 = query.getOrDefault("oauth_token")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "oauth_token", valid_579057
  var valid_579058 = query.getOrDefault("alt")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = newJString("json"))
  if valid_579058 != nil:
    section.add "alt", valid_579058
  var valid_579059 = query.getOrDefault("userIp")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "userIp", valid_579059
  var valid_579060 = query.getOrDefault("quotaUser")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "quotaUser", valid_579060
  var valid_579061 = query.getOrDefault("pageToken")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "pageToken", valid_579061
  var valid_579062 = query.getOrDefault("fields")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "fields", valid_579062
  var valid_579063 = query.getOrDefault("maxResults")
  valid_579063 = validateParameter(valid_579063, JInt, required = false, default = nil)
  if valid_579063 != nil:
    section.add "maxResults", valid_579063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579064: Call_AdexchangesellerReportsSavedList_579052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in this Ad Exchange account.
  ## 
  let valid = call_579064.validator(path, query, header, formData, body)
  let scheme = call_579064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579064.url(scheme.get, call_579064.host, call_579064.base,
                         call_579064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579064, url, valid)

proc call*(call_579065: Call_AdexchangesellerReportsSavedList_579052;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerReportsSavedList
  ## List all saved reports in this Ad Exchange account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  var query_579066 = newJObject()
  add(query_579066, "key", newJString(key))
  add(query_579066, "prettyPrint", newJBool(prettyPrint))
  add(query_579066, "oauth_token", newJString(oauthToken))
  add(query_579066, "alt", newJString(alt))
  add(query_579066, "userIp", newJString(userIp))
  add(query_579066, "quotaUser", newJString(quotaUser))
  add(query_579066, "pageToken", newJString(pageToken))
  add(query_579066, "fields", newJString(fields))
  add(query_579066, "maxResults", newJInt(maxResults))
  result = call_579065.call(nil, query_579066, nil, nil, nil)

var adexchangesellerReportsSavedList* = Call_AdexchangesellerReportsSavedList_579052(
    name: "adexchangesellerReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/saved",
    validator: validate_AdexchangesellerReportsSavedList_579053,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerReportsSavedList_579054,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsSavedGenerate_579067 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerReportsSavedGenerate_579069(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "savedReportId" in path, "`savedReportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "savedReportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerReportsSavedGenerate_579068(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   savedReportId: JString (required)
  ##                : The saved report to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `savedReportId` field"
  var valid_579070 = path.getOrDefault("savedReportId")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "savedReportId", valid_579070
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  section = newJObject()
  var valid_579071 = query.getOrDefault("key")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "key", valid_579071
  var valid_579072 = query.getOrDefault("prettyPrint")
  valid_579072 = validateParameter(valid_579072, JBool, required = false,
                                 default = newJBool(true))
  if valid_579072 != nil:
    section.add "prettyPrint", valid_579072
  var valid_579073 = query.getOrDefault("oauth_token")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "oauth_token", valid_579073
  var valid_579074 = query.getOrDefault("locale")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "locale", valid_579074
  var valid_579075 = query.getOrDefault("alt")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = newJString("json"))
  if valid_579075 != nil:
    section.add "alt", valid_579075
  var valid_579076 = query.getOrDefault("userIp")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "userIp", valid_579076
  var valid_579077 = query.getOrDefault("quotaUser")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "quotaUser", valid_579077
  var valid_579078 = query.getOrDefault("startIndex")
  valid_579078 = validateParameter(valid_579078, JInt, required = false, default = nil)
  if valid_579078 != nil:
    section.add "startIndex", valid_579078
  var valid_579079 = query.getOrDefault("fields")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "fields", valid_579079
  var valid_579080 = query.getOrDefault("maxResults")
  valid_579080 = validateParameter(valid_579080, JInt, required = false, default = nil)
  if valid_579080 != nil:
    section.add "maxResults", valid_579080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579081: Call_AdexchangesellerReportsSavedGenerate_579067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_579081.validator(path, query, header, formData, body)
  let scheme = call_579081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579081.url(scheme.get, call_579081.host, call_579081.base,
                         call_579081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579081, url, valid)

proc call*(call_579082: Call_AdexchangesellerReportsSavedGenerate_579067;
          savedReportId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; locale: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: int = 0;
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerReportsSavedGenerate
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   savedReportId: string (required)
  ##                : The saved report to retrieve.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  var path_579083 = newJObject()
  var query_579084 = newJObject()
  add(query_579084, "key", newJString(key))
  add(query_579084, "prettyPrint", newJBool(prettyPrint))
  add(query_579084, "oauth_token", newJString(oauthToken))
  add(query_579084, "locale", newJString(locale))
  add(query_579084, "alt", newJString(alt))
  add(query_579084, "userIp", newJString(userIp))
  add(path_579083, "savedReportId", newJString(savedReportId))
  add(query_579084, "quotaUser", newJString(quotaUser))
  add(query_579084, "startIndex", newJInt(startIndex))
  add(query_579084, "fields", newJString(fields))
  add(query_579084, "maxResults", newJInt(maxResults))
  result = call_579082.call(path_579083, query_579084, nil, nil, nil)

var adexchangesellerReportsSavedGenerate* = Call_AdexchangesellerReportsSavedGenerate_579067(
    name: "adexchangesellerReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{savedReportId}",
    validator: validate_AdexchangesellerReportsSavedGenerate_579068,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerReportsSavedGenerate_579069,
    schemes: {Scheme.Https})
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
