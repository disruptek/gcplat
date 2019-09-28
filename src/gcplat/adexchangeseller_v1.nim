
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
  gcpServiceName = "adexchangeseller"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdexchangesellerAdclientsList_579692 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerAdclientsList_579694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerAdclientsList_579693(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad clients in this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579806 = query.getOrDefault("fields")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "fields", valid_579806
  var valid_579807 = query.getOrDefault("pageToken")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "pageToken", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("userIp")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "userIp", valid_579824
  var valid_579825 = query.getOrDefault("maxResults")
  valid_579825 = validateParameter(valid_579825, JInt, required = false, default = nil)
  if valid_579825 != nil:
    section.add "maxResults", valid_579825
  var valid_579826 = query.getOrDefault("key")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "key", valid_579826
  var valid_579827 = query.getOrDefault("prettyPrint")
  valid_579827 = validateParameter(valid_579827, JBool, required = false,
                                 default = newJBool(true))
  if valid_579827 != nil:
    section.add "prettyPrint", valid_579827
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579850: Call_AdexchangesellerAdclientsList_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in this Ad Exchange account.
  ## 
  let valid = call_579850.validator(path, query, header, formData, body)
  let scheme = call_579850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579850.url(scheme.get, call_579850.host, call_579850.base,
                         call_579850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579850, url, valid)

proc call*(call_579921: Call_AdexchangesellerAdclientsList_579692;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAdclientsList
  ## List all ad clients in this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579922 = newJObject()
  add(query_579922, "fields", newJString(fields))
  add(query_579922, "pageToken", newJString(pageToken))
  add(query_579922, "quotaUser", newJString(quotaUser))
  add(query_579922, "alt", newJString(alt))
  add(query_579922, "oauth_token", newJString(oauthToken))
  add(query_579922, "userIp", newJString(userIp))
  add(query_579922, "maxResults", newJInt(maxResults))
  add(query_579922, "key", newJString(key))
  add(query_579922, "prettyPrint", newJBool(prettyPrint))
  result = call_579921.call(nil, query_579922, nil, nil, nil)

var adexchangesellerAdclientsList* = Call_AdexchangesellerAdclientsList_579692(
    name: "adexchangesellerAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdexchangesellerAdclientsList_579693,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerAdclientsList_579694,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsList_579962 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerAdunitsList_579964(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerAdunitsList_579963(path: JsonNode; query: JsonNode;
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
  var valid_579979 = path.getOrDefault("adClientId")
  valid_579979 = validateParameter(valid_579979, JString, required = true,
                                 default = nil)
  if valid_579979 != nil:
    section.add "adClientId", valid_579979
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579980 = query.getOrDefault("fields")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "fields", valid_579980
  var valid_579981 = query.getOrDefault("pageToken")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "pageToken", valid_579981
  var valid_579982 = query.getOrDefault("quotaUser")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "quotaUser", valid_579982
  var valid_579983 = query.getOrDefault("alt")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("json"))
  if valid_579983 != nil:
    section.add "alt", valid_579983
  var valid_579984 = query.getOrDefault("includeInactive")
  valid_579984 = validateParameter(valid_579984, JBool, required = false, default = nil)
  if valid_579984 != nil:
    section.add "includeInactive", valid_579984
  var valid_579985 = query.getOrDefault("oauth_token")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "oauth_token", valid_579985
  var valid_579986 = query.getOrDefault("userIp")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "userIp", valid_579986
  var valid_579987 = query.getOrDefault("maxResults")
  valid_579987 = validateParameter(valid_579987, JInt, required = false, default = nil)
  if valid_579987 != nil:
    section.add "maxResults", valid_579987
  var valid_579988 = query.getOrDefault("key")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "key", valid_579988
  var valid_579989 = query.getOrDefault("prettyPrint")
  valid_579989 = validateParameter(valid_579989, JBool, required = false,
                                 default = newJBool(true))
  if valid_579989 != nil:
    section.add "prettyPrint", valid_579989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579990: Call_AdexchangesellerAdunitsList_579962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_579990.validator(path, query, header, formData, body)
  let scheme = call_579990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579990.url(scheme.get, call_579990.host, call_579990.base,
                         call_579990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579990, url, valid)

proc call*(call_579991: Call_AdexchangesellerAdunitsList_579962;
          adClientId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; includeInactive: bool = false;
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAdunitsList
  ## List all ad units in the specified ad client for this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list ad units.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579992 = newJObject()
  var query_579993 = newJObject()
  add(query_579993, "fields", newJString(fields))
  add(query_579993, "pageToken", newJString(pageToken))
  add(query_579993, "quotaUser", newJString(quotaUser))
  add(query_579993, "alt", newJString(alt))
  add(query_579993, "includeInactive", newJBool(includeInactive))
  add(query_579993, "oauth_token", newJString(oauthToken))
  add(query_579993, "userIp", newJString(userIp))
  add(query_579993, "maxResults", newJInt(maxResults))
  add(query_579993, "key", newJString(key))
  add(path_579992, "adClientId", newJString(adClientId))
  add(query_579993, "prettyPrint", newJBool(prettyPrint))
  result = call_579991.call(path_579992, query_579993, nil, nil, nil)

var adexchangesellerAdunitsList* = Call_AdexchangesellerAdunitsList_579962(
    name: "adexchangesellerAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/adunits",
    validator: validate_AdexchangesellerAdunitsList_579963,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerAdunitsList_579964,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsGet_579994 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerAdunitsGet_579996(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerAdunitsGet_579995(path: JsonNode; query: JsonNode;
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
  var valid_579997 = path.getOrDefault("adClientId")
  valid_579997 = validateParameter(valid_579997, JString, required = true,
                                 default = nil)
  if valid_579997 != nil:
    section.add "adClientId", valid_579997
  var valid_579998 = path.getOrDefault("adUnitId")
  valid_579998 = validateParameter(valid_579998, JString, required = true,
                                 default = nil)
  if valid_579998 != nil:
    section.add "adUnitId", valid_579998
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579999 = query.getOrDefault("fields")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "fields", valid_579999
  var valid_580000 = query.getOrDefault("quotaUser")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "quotaUser", valid_580000
  var valid_580001 = query.getOrDefault("alt")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("json"))
  if valid_580001 != nil:
    section.add "alt", valid_580001
  var valid_580002 = query.getOrDefault("oauth_token")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "oauth_token", valid_580002
  var valid_580003 = query.getOrDefault("userIp")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "userIp", valid_580003
  var valid_580004 = query.getOrDefault("key")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "key", valid_580004
  var valid_580005 = query.getOrDefault("prettyPrint")
  valid_580005 = validateParameter(valid_580005, JBool, required = false,
                                 default = newJBool(true))
  if valid_580005 != nil:
    section.add "prettyPrint", valid_580005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580006: Call_AdexchangesellerAdunitsGet_579994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_AdexchangesellerAdunitsGet_579994; adClientId: string;
          adUnitId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAdunitsGet
  ## Gets the specified ad unit in the specified ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580008 = newJObject()
  var query_580009 = newJObject()
  add(query_580009, "fields", newJString(fields))
  add(query_580009, "quotaUser", newJString(quotaUser))
  add(query_580009, "alt", newJString(alt))
  add(query_580009, "oauth_token", newJString(oauthToken))
  add(query_580009, "userIp", newJString(userIp))
  add(query_580009, "key", newJString(key))
  add(path_580008, "adClientId", newJString(adClientId))
  add(path_580008, "adUnitId", newJString(adUnitId))
  add(query_580009, "prettyPrint", newJBool(prettyPrint))
  result = call_580007.call(path_580008, query_580009, nil, nil, nil)

var adexchangesellerAdunitsGet* = Call_AdexchangesellerAdunitsGet_579994(
    name: "adexchangesellerAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdexchangesellerAdunitsGet_579995,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerAdunitsGet_579996,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsCustomchannelsList_580010 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerAdunitsCustomchannelsList_580012(protocol: Scheme;
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

proc validate_AdexchangesellerAdunitsCustomchannelsList_580011(path: JsonNode;
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
  var valid_580013 = path.getOrDefault("adClientId")
  valid_580013 = validateParameter(valid_580013, JString, required = true,
                                 default = nil)
  if valid_580013 != nil:
    section.add "adClientId", valid_580013
  var valid_580014 = path.getOrDefault("adUnitId")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "adUnitId", valid_580014
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580015 = query.getOrDefault("fields")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "fields", valid_580015
  var valid_580016 = query.getOrDefault("pageToken")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "pageToken", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("alt")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("json"))
  if valid_580018 != nil:
    section.add "alt", valid_580018
  var valid_580019 = query.getOrDefault("oauth_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "oauth_token", valid_580019
  var valid_580020 = query.getOrDefault("userIp")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "userIp", valid_580020
  var valid_580021 = query.getOrDefault("maxResults")
  valid_580021 = validateParameter(valid_580021, JInt, required = false, default = nil)
  if valid_580021 != nil:
    section.add "maxResults", valid_580021
  var valid_580022 = query.getOrDefault("key")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "key", valid_580022
  var valid_580023 = query.getOrDefault("prettyPrint")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(true))
  if valid_580023 != nil:
    section.add "prettyPrint", valid_580023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580024: Call_AdexchangesellerAdunitsCustomchannelsList_580010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_580024.validator(path, query, header, formData, body)
  let scheme = call_580024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580024.url(scheme.get, call_580024.host, call_580024.base,
                         call_580024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580024, url, valid)

proc call*(call_580025: Call_AdexchangesellerAdunitsCustomchannelsList_580010;
          adClientId: string; adUnitId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAdunitsCustomchannelsList
  ## List all custom channels which the specified ad unit belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit for which to list custom channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580026 = newJObject()
  var query_580027 = newJObject()
  add(query_580027, "fields", newJString(fields))
  add(query_580027, "pageToken", newJString(pageToken))
  add(query_580027, "quotaUser", newJString(quotaUser))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "userIp", newJString(userIp))
  add(query_580027, "maxResults", newJInt(maxResults))
  add(query_580027, "key", newJString(key))
  add(path_580026, "adClientId", newJString(adClientId))
  add(path_580026, "adUnitId", newJString(adUnitId))
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  result = call_580025.call(path_580026, query_580027, nil, nil, nil)

var adexchangesellerAdunitsCustomchannelsList* = Call_AdexchangesellerAdunitsCustomchannelsList_580010(
    name: "adexchangesellerAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdexchangesellerAdunitsCustomchannelsList_580011,
    base: "/adexchangeseller/v1",
    url: url_AdexchangesellerAdunitsCustomchannelsList_580012,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsList_580028 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerCustomchannelsList_580030(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerCustomchannelsList_580029(path: JsonNode;
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
  var valid_580031 = path.getOrDefault("adClientId")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "adClientId", valid_580031
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580032 = query.getOrDefault("fields")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "fields", valid_580032
  var valid_580033 = query.getOrDefault("pageToken")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "pageToken", valid_580033
  var valid_580034 = query.getOrDefault("quotaUser")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "quotaUser", valid_580034
  var valid_580035 = query.getOrDefault("alt")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("json"))
  if valid_580035 != nil:
    section.add "alt", valid_580035
  var valid_580036 = query.getOrDefault("oauth_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "oauth_token", valid_580036
  var valid_580037 = query.getOrDefault("userIp")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "userIp", valid_580037
  var valid_580038 = query.getOrDefault("maxResults")
  valid_580038 = validateParameter(valid_580038, JInt, required = false, default = nil)
  if valid_580038 != nil:
    section.add "maxResults", valid_580038
  var valid_580039 = query.getOrDefault("key")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "key", valid_580039
  var valid_580040 = query.getOrDefault("prettyPrint")
  valid_580040 = validateParameter(valid_580040, JBool, required = false,
                                 default = newJBool(true))
  if valid_580040 != nil:
    section.add "prettyPrint", valid_580040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580041: Call_AdexchangesellerCustomchannelsList_580028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_580041.validator(path, query, header, formData, body)
  let scheme = call_580041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580041.url(scheme.get, call_580041.host, call_580041.base,
                         call_580041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580041, url, valid)

proc call*(call_580042: Call_AdexchangesellerCustomchannelsList_580028;
          adClientId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerCustomchannelsList
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list custom channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580043 = newJObject()
  var query_580044 = newJObject()
  add(query_580044, "fields", newJString(fields))
  add(query_580044, "pageToken", newJString(pageToken))
  add(query_580044, "quotaUser", newJString(quotaUser))
  add(query_580044, "alt", newJString(alt))
  add(query_580044, "oauth_token", newJString(oauthToken))
  add(query_580044, "userIp", newJString(userIp))
  add(query_580044, "maxResults", newJInt(maxResults))
  add(query_580044, "key", newJString(key))
  add(path_580043, "adClientId", newJString(adClientId))
  add(query_580044, "prettyPrint", newJBool(prettyPrint))
  result = call_580042.call(path_580043, query_580044, nil, nil, nil)

var adexchangesellerCustomchannelsList* = Call_AdexchangesellerCustomchannelsList_580028(
    name: "adexchangesellerCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdexchangesellerCustomchannelsList_580029,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerCustomchannelsList_580030,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsGet_580045 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerCustomchannelsGet_580047(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerCustomchannelsGet_580046(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified custom channel from the specified ad client.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customChannelId: JString (required)
  ##                  : Custom channel to retrieve.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customChannelId` field"
  var valid_580048 = path.getOrDefault("customChannelId")
  valid_580048 = validateParameter(valid_580048, JString, required = true,
                                 default = nil)
  if valid_580048 != nil:
    section.add "customChannelId", valid_580048
  var valid_580049 = path.getOrDefault("adClientId")
  valid_580049 = validateParameter(valid_580049, JString, required = true,
                                 default = nil)
  if valid_580049 != nil:
    section.add "adClientId", valid_580049
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580050 = query.getOrDefault("fields")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "fields", valid_580050
  var valid_580051 = query.getOrDefault("quotaUser")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "quotaUser", valid_580051
  var valid_580052 = query.getOrDefault("alt")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = newJString("json"))
  if valid_580052 != nil:
    section.add "alt", valid_580052
  var valid_580053 = query.getOrDefault("oauth_token")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "oauth_token", valid_580053
  var valid_580054 = query.getOrDefault("userIp")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "userIp", valid_580054
  var valid_580055 = query.getOrDefault("key")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "key", valid_580055
  var valid_580056 = query.getOrDefault("prettyPrint")
  valid_580056 = validateParameter(valid_580056, JBool, required = false,
                                 default = newJBool(true))
  if valid_580056 != nil:
    section.add "prettyPrint", valid_580056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580057: Call_AdexchangesellerCustomchannelsGet_580045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_580057.validator(path, query, header, formData, body)
  let scheme = call_580057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580057.url(scheme.get, call_580057.host, call_580057.base,
                         call_580057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580057, url, valid)

proc call*(call_580058: Call_AdexchangesellerCustomchannelsGet_580045;
          customChannelId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerCustomchannelsGet
  ## Get the specified custom channel from the specified ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customChannelId: string (required)
  ##                  : Custom channel to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580059 = newJObject()
  var query_580060 = newJObject()
  add(query_580060, "fields", newJString(fields))
  add(query_580060, "quotaUser", newJString(quotaUser))
  add(query_580060, "alt", newJString(alt))
  add(query_580060, "oauth_token", newJString(oauthToken))
  add(path_580059, "customChannelId", newJString(customChannelId))
  add(query_580060, "userIp", newJString(userIp))
  add(query_580060, "key", newJString(key))
  add(path_580059, "adClientId", newJString(adClientId))
  add(query_580060, "prettyPrint", newJBool(prettyPrint))
  result = call_580058.call(path_580059, query_580060, nil, nil, nil)

var adexchangesellerCustomchannelsGet* = Call_AdexchangesellerCustomchannelsGet_580045(
    name: "adexchangesellerCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdexchangesellerCustomchannelsGet_580046,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerCustomchannelsGet_580047,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsAdunitsList_580061 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerCustomchannelsAdunitsList_580063(protocol: Scheme;
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

proc validate_AdexchangesellerCustomchannelsAdunitsList_580062(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified custom channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customChannelId: JString (required)
  ##                  : Custom channel for which to list ad units.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customChannelId` field"
  var valid_580064 = path.getOrDefault("customChannelId")
  valid_580064 = validateParameter(valid_580064, JString, required = true,
                                 default = nil)
  if valid_580064 != nil:
    section.add "customChannelId", valid_580064
  var valid_580065 = path.getOrDefault("adClientId")
  valid_580065 = validateParameter(valid_580065, JString, required = true,
                                 default = nil)
  if valid_580065 != nil:
    section.add "adClientId", valid_580065
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580066 = query.getOrDefault("fields")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "fields", valid_580066
  var valid_580067 = query.getOrDefault("pageToken")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "pageToken", valid_580067
  var valid_580068 = query.getOrDefault("quotaUser")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "quotaUser", valid_580068
  var valid_580069 = query.getOrDefault("alt")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = newJString("json"))
  if valid_580069 != nil:
    section.add "alt", valid_580069
  var valid_580070 = query.getOrDefault("includeInactive")
  valid_580070 = validateParameter(valid_580070, JBool, required = false, default = nil)
  if valid_580070 != nil:
    section.add "includeInactive", valid_580070
  var valid_580071 = query.getOrDefault("oauth_token")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "oauth_token", valid_580071
  var valid_580072 = query.getOrDefault("userIp")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "userIp", valid_580072
  var valid_580073 = query.getOrDefault("maxResults")
  valid_580073 = validateParameter(valid_580073, JInt, required = false, default = nil)
  if valid_580073 != nil:
    section.add "maxResults", valid_580073
  var valid_580074 = query.getOrDefault("key")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "key", valid_580074
  var valid_580075 = query.getOrDefault("prettyPrint")
  valid_580075 = validateParameter(valid_580075, JBool, required = false,
                                 default = newJBool(true))
  if valid_580075 != nil:
    section.add "prettyPrint", valid_580075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580076: Call_AdexchangesellerCustomchannelsAdunitsList_580061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_580076.validator(path, query, header, formData, body)
  let scheme = call_580076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580076.url(scheme.get, call_580076.host, call_580076.base,
                         call_580076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580076, url, valid)

proc call*(call_580077: Call_AdexchangesellerCustomchannelsAdunitsList_580061;
          customChannelId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          includeInactive: bool = false; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerCustomchannelsAdunitsList
  ## List all ad units in the specified custom channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customChannelId: string (required)
  ##                  : Custom channel for which to list ad units.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580078 = newJObject()
  var query_580079 = newJObject()
  add(query_580079, "fields", newJString(fields))
  add(query_580079, "pageToken", newJString(pageToken))
  add(query_580079, "quotaUser", newJString(quotaUser))
  add(query_580079, "alt", newJString(alt))
  add(query_580079, "includeInactive", newJBool(includeInactive))
  add(query_580079, "oauth_token", newJString(oauthToken))
  add(path_580078, "customChannelId", newJString(customChannelId))
  add(query_580079, "userIp", newJString(userIp))
  add(query_580079, "maxResults", newJInt(maxResults))
  add(query_580079, "key", newJString(key))
  add(path_580078, "adClientId", newJString(adClientId))
  add(query_580079, "prettyPrint", newJBool(prettyPrint))
  result = call_580077.call(path_580078, query_580079, nil, nil, nil)

var adexchangesellerCustomchannelsAdunitsList* = Call_AdexchangesellerCustomchannelsAdunitsList_580061(
    name: "adexchangesellerCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdexchangesellerCustomchannelsAdunitsList_580062,
    base: "/adexchangeseller/v1",
    url: url_AdexchangesellerCustomchannelsAdunitsList_580063,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerUrlchannelsList_580080 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerUrlchannelsList_580082(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerUrlchannelsList_580081(path: JsonNode;
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
  var valid_580083 = path.getOrDefault("adClientId")
  valid_580083 = validateParameter(valid_580083, JString, required = true,
                                 default = nil)
  if valid_580083 != nil:
    section.add "adClientId", valid_580083
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580084 = query.getOrDefault("fields")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "fields", valid_580084
  var valid_580085 = query.getOrDefault("pageToken")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "pageToken", valid_580085
  var valid_580086 = query.getOrDefault("quotaUser")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "quotaUser", valid_580086
  var valid_580087 = query.getOrDefault("alt")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = newJString("json"))
  if valid_580087 != nil:
    section.add "alt", valid_580087
  var valid_580088 = query.getOrDefault("oauth_token")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "oauth_token", valid_580088
  var valid_580089 = query.getOrDefault("userIp")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "userIp", valid_580089
  var valid_580090 = query.getOrDefault("maxResults")
  valid_580090 = validateParameter(valid_580090, JInt, required = false, default = nil)
  if valid_580090 != nil:
    section.add "maxResults", valid_580090
  var valid_580091 = query.getOrDefault("key")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "key", valid_580091
  var valid_580092 = query.getOrDefault("prettyPrint")
  valid_580092 = validateParameter(valid_580092, JBool, required = false,
                                 default = newJBool(true))
  if valid_580092 != nil:
    section.add "prettyPrint", valid_580092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580093: Call_AdexchangesellerUrlchannelsList_580080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_580093.validator(path, query, header, formData, body)
  let scheme = call_580093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580093.url(scheme.get, call_580093.host, call_580093.base,
                         call_580093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580093, url, valid)

proc call*(call_580094: Call_AdexchangesellerUrlchannelsList_580080;
          adClientId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerUrlchannelsList
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list URL channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580095 = newJObject()
  var query_580096 = newJObject()
  add(query_580096, "fields", newJString(fields))
  add(query_580096, "pageToken", newJString(pageToken))
  add(query_580096, "quotaUser", newJString(quotaUser))
  add(query_580096, "alt", newJString(alt))
  add(query_580096, "oauth_token", newJString(oauthToken))
  add(query_580096, "userIp", newJString(userIp))
  add(query_580096, "maxResults", newJInt(maxResults))
  add(query_580096, "key", newJString(key))
  add(path_580095, "adClientId", newJString(adClientId))
  add(query_580096, "prettyPrint", newJBool(prettyPrint))
  result = call_580094.call(path_580095, query_580096, nil, nil, nil)

var adexchangesellerUrlchannelsList* = Call_AdexchangesellerUrlchannelsList_580080(
    name: "adexchangesellerUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdexchangesellerUrlchannelsList_580081,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerUrlchannelsList_580082,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsGenerate_580097 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerReportsGenerate_580099(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerReportsGenerate_580098(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JString (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   startDate: JString (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  section = newJObject()
  var valid_580100 = query.getOrDefault("locale")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "locale", valid_580100
  var valid_580101 = query.getOrDefault("fields")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "fields", valid_580101
  var valid_580102 = query.getOrDefault("quotaUser")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "quotaUser", valid_580102
  var valid_580103 = query.getOrDefault("alt")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("json"))
  if valid_580103 != nil:
    section.add "alt", valid_580103
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_580104 = query.getOrDefault("endDate")
  valid_580104 = validateParameter(valid_580104, JString, required = true,
                                 default = nil)
  if valid_580104 != nil:
    section.add "endDate", valid_580104
  var valid_580105 = query.getOrDefault("startDate")
  valid_580105 = validateParameter(valid_580105, JString, required = true,
                                 default = nil)
  if valid_580105 != nil:
    section.add "startDate", valid_580105
  var valid_580106 = query.getOrDefault("sort")
  valid_580106 = validateParameter(valid_580106, JArray, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "sort", valid_580106
  var valid_580107 = query.getOrDefault("oauth_token")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "oauth_token", valid_580107
  var valid_580108 = query.getOrDefault("userIp")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "userIp", valid_580108
  var valid_580109 = query.getOrDefault("maxResults")
  valid_580109 = validateParameter(valid_580109, JInt, required = false, default = nil)
  if valid_580109 != nil:
    section.add "maxResults", valid_580109
  var valid_580110 = query.getOrDefault("key")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "key", valid_580110
  var valid_580111 = query.getOrDefault("metric")
  valid_580111 = validateParameter(valid_580111, JArray, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "metric", valid_580111
  var valid_580112 = query.getOrDefault("prettyPrint")
  valid_580112 = validateParameter(valid_580112, JBool, required = false,
                                 default = newJBool(true))
  if valid_580112 != nil:
    section.add "prettyPrint", valid_580112
  var valid_580113 = query.getOrDefault("dimension")
  valid_580113 = validateParameter(valid_580113, JArray, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "dimension", valid_580113
  var valid_580114 = query.getOrDefault("filter")
  valid_580114 = validateParameter(valid_580114, JArray, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "filter", valid_580114
  var valid_580115 = query.getOrDefault("startIndex")
  valid_580115 = validateParameter(valid_580115, JInt, required = false, default = nil)
  if valid_580115 != nil:
    section.add "startIndex", valid_580115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580116: Call_AdexchangesellerReportsGenerate_580097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_580116.validator(path, query, header, formData, body)
  let scheme = call_580116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580116.url(scheme.get, call_580116.host, call_580116.base,
                         call_580116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580116, url, valid)

proc call*(call_580117: Call_AdexchangesellerReportsGenerate_580097;
          endDate: string; startDate: string; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; sort: JsonNode = nil;
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; metric: JsonNode = nil; prettyPrint: bool = true;
          dimension: JsonNode = nil; filter: JsonNode = nil; startIndex: int = 0): Recallable =
  ## adexchangesellerReportsGenerate
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   startDate: string (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  var query_580118 = newJObject()
  add(query_580118, "locale", newJString(locale))
  add(query_580118, "fields", newJString(fields))
  add(query_580118, "quotaUser", newJString(quotaUser))
  add(query_580118, "alt", newJString(alt))
  add(query_580118, "endDate", newJString(endDate))
  add(query_580118, "startDate", newJString(startDate))
  if sort != nil:
    query_580118.add "sort", sort
  add(query_580118, "oauth_token", newJString(oauthToken))
  add(query_580118, "userIp", newJString(userIp))
  add(query_580118, "maxResults", newJInt(maxResults))
  add(query_580118, "key", newJString(key))
  if metric != nil:
    query_580118.add "metric", metric
  add(query_580118, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_580118.add "dimension", dimension
  if filter != nil:
    query_580118.add "filter", filter
  add(query_580118, "startIndex", newJInt(startIndex))
  result = call_580117.call(nil, query_580118, nil, nil, nil)

var adexchangesellerReportsGenerate* = Call_AdexchangesellerReportsGenerate_580097(
    name: "adexchangesellerReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdexchangesellerReportsGenerate_580098,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerReportsGenerate_580099,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsSavedList_580119 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerReportsSavedList_580121(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerReportsSavedList_580120(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved reports in this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580122 = query.getOrDefault("fields")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "fields", valid_580122
  var valid_580123 = query.getOrDefault("pageToken")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "pageToken", valid_580123
  var valid_580124 = query.getOrDefault("quotaUser")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "quotaUser", valid_580124
  var valid_580125 = query.getOrDefault("alt")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("json"))
  if valid_580125 != nil:
    section.add "alt", valid_580125
  var valid_580126 = query.getOrDefault("oauth_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "oauth_token", valid_580126
  var valid_580127 = query.getOrDefault("userIp")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "userIp", valid_580127
  var valid_580128 = query.getOrDefault("maxResults")
  valid_580128 = validateParameter(valid_580128, JInt, required = false, default = nil)
  if valid_580128 != nil:
    section.add "maxResults", valid_580128
  var valid_580129 = query.getOrDefault("key")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "key", valid_580129
  var valid_580130 = query.getOrDefault("prettyPrint")
  valid_580130 = validateParameter(valid_580130, JBool, required = false,
                                 default = newJBool(true))
  if valid_580130 != nil:
    section.add "prettyPrint", valid_580130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580131: Call_AdexchangesellerReportsSavedList_580119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in this Ad Exchange account.
  ## 
  let valid = call_580131.validator(path, query, header, formData, body)
  let scheme = call_580131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580131.url(scheme.get, call_580131.host, call_580131.base,
                         call_580131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580131, url, valid)

proc call*(call_580132: Call_AdexchangesellerReportsSavedList_580119;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerReportsSavedList
  ## List all saved reports in this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580133 = newJObject()
  add(query_580133, "fields", newJString(fields))
  add(query_580133, "pageToken", newJString(pageToken))
  add(query_580133, "quotaUser", newJString(quotaUser))
  add(query_580133, "alt", newJString(alt))
  add(query_580133, "oauth_token", newJString(oauthToken))
  add(query_580133, "userIp", newJString(userIp))
  add(query_580133, "maxResults", newJInt(maxResults))
  add(query_580133, "key", newJString(key))
  add(query_580133, "prettyPrint", newJBool(prettyPrint))
  result = call_580132.call(nil, query_580133, nil, nil, nil)

var adexchangesellerReportsSavedList* = Call_AdexchangesellerReportsSavedList_580119(
    name: "adexchangesellerReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/saved",
    validator: validate_AdexchangesellerReportsSavedList_580120,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerReportsSavedList_580121,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsSavedGenerate_580134 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerReportsSavedGenerate_580136(protocol: Scheme;
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

proc validate_AdexchangesellerReportsSavedGenerate_580135(path: JsonNode;
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
  var valid_580137 = path.getOrDefault("savedReportId")
  valid_580137 = validateParameter(valid_580137, JString, required = true,
                                 default = nil)
  if valid_580137 != nil:
    section.add "savedReportId", valid_580137
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  section = newJObject()
  var valid_580138 = query.getOrDefault("locale")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "locale", valid_580138
  var valid_580139 = query.getOrDefault("fields")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "fields", valid_580139
  var valid_580140 = query.getOrDefault("quotaUser")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "quotaUser", valid_580140
  var valid_580141 = query.getOrDefault("alt")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = newJString("json"))
  if valid_580141 != nil:
    section.add "alt", valid_580141
  var valid_580142 = query.getOrDefault("oauth_token")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "oauth_token", valid_580142
  var valid_580143 = query.getOrDefault("userIp")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "userIp", valid_580143
  var valid_580144 = query.getOrDefault("maxResults")
  valid_580144 = validateParameter(valid_580144, JInt, required = false, default = nil)
  if valid_580144 != nil:
    section.add "maxResults", valid_580144
  var valid_580145 = query.getOrDefault("key")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "key", valid_580145
  var valid_580146 = query.getOrDefault("prettyPrint")
  valid_580146 = validateParameter(valid_580146, JBool, required = false,
                                 default = newJBool(true))
  if valid_580146 != nil:
    section.add "prettyPrint", valid_580146
  var valid_580147 = query.getOrDefault("startIndex")
  valid_580147 = validateParameter(valid_580147, JInt, required = false, default = nil)
  if valid_580147 != nil:
    section.add "startIndex", valid_580147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580148: Call_AdexchangesellerReportsSavedGenerate_580134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_580148.validator(path, query, header, formData, body)
  let scheme = call_580148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580148.url(scheme.get, call_580148.host, call_580148.base,
                         call_580148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580148, url, valid)

proc call*(call_580149: Call_AdexchangesellerReportsSavedGenerate_580134;
          savedReportId: string; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## adexchangesellerReportsSavedGenerate
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   savedReportId: string (required)
  ##                : The saved report to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  var path_580150 = newJObject()
  var query_580151 = newJObject()
  add(query_580151, "locale", newJString(locale))
  add(query_580151, "fields", newJString(fields))
  add(query_580151, "quotaUser", newJString(quotaUser))
  add(query_580151, "alt", newJString(alt))
  add(query_580151, "oauth_token", newJString(oauthToken))
  add(query_580151, "userIp", newJString(userIp))
  add(query_580151, "maxResults", newJInt(maxResults))
  add(path_580150, "savedReportId", newJString(savedReportId))
  add(query_580151, "key", newJString(key))
  add(query_580151, "prettyPrint", newJBool(prettyPrint))
  add(query_580151, "startIndex", newJInt(startIndex))
  result = call_580149.call(path_580150, query_580151, nil, nil, nil)

var adexchangesellerReportsSavedGenerate* = Call_AdexchangesellerReportsSavedGenerate_580134(
    name: "adexchangesellerReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{savedReportId}",
    validator: validate_AdexchangesellerReportsSavedGenerate_580135,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerReportsSavedGenerate_580136,
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
