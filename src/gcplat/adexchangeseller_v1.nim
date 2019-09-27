
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597424): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdexchangesellerAdclientsList_597692 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAdclientsList_597694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangesellerAdclientsList_597693(path: JsonNode; query: JsonNode;
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
  var valid_597806 = query.getOrDefault("fields")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "fields", valid_597806
  var valid_597807 = query.getOrDefault("pageToken")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "pageToken", valid_597807
  var valid_597808 = query.getOrDefault("quotaUser")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "quotaUser", valid_597808
  var valid_597822 = query.getOrDefault("alt")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = newJString("json"))
  if valid_597822 != nil:
    section.add "alt", valid_597822
  var valid_597823 = query.getOrDefault("oauth_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "oauth_token", valid_597823
  var valid_597824 = query.getOrDefault("userIp")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "userIp", valid_597824
  var valid_597825 = query.getOrDefault("maxResults")
  valid_597825 = validateParameter(valid_597825, JInt, required = false, default = nil)
  if valid_597825 != nil:
    section.add "maxResults", valid_597825
  var valid_597826 = query.getOrDefault("key")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "key", valid_597826
  var valid_597827 = query.getOrDefault("prettyPrint")
  valid_597827 = validateParameter(valid_597827, JBool, required = false,
                                 default = newJBool(true))
  if valid_597827 != nil:
    section.add "prettyPrint", valid_597827
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597850: Call_AdexchangesellerAdclientsList_597692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in this Ad Exchange account.
  ## 
  let valid = call_597850.validator(path, query, header, formData, body)
  let scheme = call_597850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597850.url(scheme.get, call_597850.host, call_597850.base,
                         call_597850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597850, url, valid)

proc call*(call_597921: Call_AdexchangesellerAdclientsList_597692;
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
  var query_597922 = newJObject()
  add(query_597922, "fields", newJString(fields))
  add(query_597922, "pageToken", newJString(pageToken))
  add(query_597922, "quotaUser", newJString(quotaUser))
  add(query_597922, "alt", newJString(alt))
  add(query_597922, "oauth_token", newJString(oauthToken))
  add(query_597922, "userIp", newJString(userIp))
  add(query_597922, "maxResults", newJInt(maxResults))
  add(query_597922, "key", newJString(key))
  add(query_597922, "prettyPrint", newJBool(prettyPrint))
  result = call_597921.call(nil, query_597922, nil, nil, nil)

var adexchangesellerAdclientsList* = Call_AdexchangesellerAdclientsList_597692(
    name: "adexchangesellerAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdexchangesellerAdclientsList_597693,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerAdclientsList_597694,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsList_597962 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAdunitsList_597964(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerAdunitsList_597963(path: JsonNode; query: JsonNode;
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
  var valid_597979 = path.getOrDefault("adClientId")
  valid_597979 = validateParameter(valid_597979, JString, required = true,
                                 default = nil)
  if valid_597979 != nil:
    section.add "adClientId", valid_597979
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
  var valid_597980 = query.getOrDefault("fields")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "fields", valid_597980
  var valid_597981 = query.getOrDefault("pageToken")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "pageToken", valid_597981
  var valid_597982 = query.getOrDefault("quotaUser")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "quotaUser", valid_597982
  var valid_597983 = query.getOrDefault("alt")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = newJString("json"))
  if valid_597983 != nil:
    section.add "alt", valid_597983
  var valid_597984 = query.getOrDefault("includeInactive")
  valid_597984 = validateParameter(valid_597984, JBool, required = false, default = nil)
  if valid_597984 != nil:
    section.add "includeInactive", valid_597984
  var valid_597985 = query.getOrDefault("oauth_token")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = nil)
  if valid_597985 != nil:
    section.add "oauth_token", valid_597985
  var valid_597986 = query.getOrDefault("userIp")
  valid_597986 = validateParameter(valid_597986, JString, required = false,
                                 default = nil)
  if valid_597986 != nil:
    section.add "userIp", valid_597986
  var valid_597987 = query.getOrDefault("maxResults")
  valid_597987 = validateParameter(valid_597987, JInt, required = false, default = nil)
  if valid_597987 != nil:
    section.add "maxResults", valid_597987
  var valid_597988 = query.getOrDefault("key")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "key", valid_597988
  var valid_597989 = query.getOrDefault("prettyPrint")
  valid_597989 = validateParameter(valid_597989, JBool, required = false,
                                 default = newJBool(true))
  if valid_597989 != nil:
    section.add "prettyPrint", valid_597989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597990: Call_AdexchangesellerAdunitsList_597962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_597990.validator(path, query, header, formData, body)
  let scheme = call_597990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597990.url(scheme.get, call_597990.host, call_597990.base,
                         call_597990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597990, url, valid)

proc call*(call_597991: Call_AdexchangesellerAdunitsList_597962;
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
  var path_597992 = newJObject()
  var query_597993 = newJObject()
  add(query_597993, "fields", newJString(fields))
  add(query_597993, "pageToken", newJString(pageToken))
  add(query_597993, "quotaUser", newJString(quotaUser))
  add(query_597993, "alt", newJString(alt))
  add(query_597993, "includeInactive", newJBool(includeInactive))
  add(query_597993, "oauth_token", newJString(oauthToken))
  add(query_597993, "userIp", newJString(userIp))
  add(query_597993, "maxResults", newJInt(maxResults))
  add(query_597993, "key", newJString(key))
  add(path_597992, "adClientId", newJString(adClientId))
  add(query_597993, "prettyPrint", newJBool(prettyPrint))
  result = call_597991.call(path_597992, query_597993, nil, nil, nil)

var adexchangesellerAdunitsList* = Call_AdexchangesellerAdunitsList_597962(
    name: "adexchangesellerAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/adunits",
    validator: validate_AdexchangesellerAdunitsList_597963,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerAdunitsList_597964,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsGet_597994 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAdunitsGet_597996(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerAdunitsGet_597995(path: JsonNode; query: JsonNode;
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
  var valid_597997 = path.getOrDefault("adClientId")
  valid_597997 = validateParameter(valid_597997, JString, required = true,
                                 default = nil)
  if valid_597997 != nil:
    section.add "adClientId", valid_597997
  var valid_597998 = path.getOrDefault("adUnitId")
  valid_597998 = validateParameter(valid_597998, JString, required = true,
                                 default = nil)
  if valid_597998 != nil:
    section.add "adUnitId", valid_597998
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
  var valid_597999 = query.getOrDefault("fields")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "fields", valid_597999
  var valid_598000 = query.getOrDefault("quotaUser")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "quotaUser", valid_598000
  var valid_598001 = query.getOrDefault("alt")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = newJString("json"))
  if valid_598001 != nil:
    section.add "alt", valid_598001
  var valid_598002 = query.getOrDefault("oauth_token")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "oauth_token", valid_598002
  var valid_598003 = query.getOrDefault("userIp")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "userIp", valid_598003
  var valid_598004 = query.getOrDefault("key")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "key", valid_598004
  var valid_598005 = query.getOrDefault("prettyPrint")
  valid_598005 = validateParameter(valid_598005, JBool, required = false,
                                 default = newJBool(true))
  if valid_598005 != nil:
    section.add "prettyPrint", valid_598005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598006: Call_AdexchangesellerAdunitsGet_597994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  let valid = call_598006.validator(path, query, header, formData, body)
  let scheme = call_598006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598006.url(scheme.get, call_598006.host, call_598006.base,
                         call_598006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598006, url, valid)

proc call*(call_598007: Call_AdexchangesellerAdunitsGet_597994; adClientId: string;
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
  var path_598008 = newJObject()
  var query_598009 = newJObject()
  add(query_598009, "fields", newJString(fields))
  add(query_598009, "quotaUser", newJString(quotaUser))
  add(query_598009, "alt", newJString(alt))
  add(query_598009, "oauth_token", newJString(oauthToken))
  add(query_598009, "userIp", newJString(userIp))
  add(query_598009, "key", newJString(key))
  add(path_598008, "adClientId", newJString(adClientId))
  add(path_598008, "adUnitId", newJString(adUnitId))
  add(query_598009, "prettyPrint", newJBool(prettyPrint))
  result = call_598007.call(path_598008, query_598009, nil, nil, nil)

var adexchangesellerAdunitsGet* = Call_AdexchangesellerAdunitsGet_597994(
    name: "adexchangesellerAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdexchangesellerAdunitsGet_597995,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerAdunitsGet_597996,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsCustomchannelsList_598010 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAdunitsCustomchannelsList_598012(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerAdunitsCustomchannelsList_598011(path: JsonNode;
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
  var valid_598013 = path.getOrDefault("adClientId")
  valid_598013 = validateParameter(valid_598013, JString, required = true,
                                 default = nil)
  if valid_598013 != nil:
    section.add "adClientId", valid_598013
  var valid_598014 = path.getOrDefault("adUnitId")
  valid_598014 = validateParameter(valid_598014, JString, required = true,
                                 default = nil)
  if valid_598014 != nil:
    section.add "adUnitId", valid_598014
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
  var valid_598015 = query.getOrDefault("fields")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "fields", valid_598015
  var valid_598016 = query.getOrDefault("pageToken")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "pageToken", valid_598016
  var valid_598017 = query.getOrDefault("quotaUser")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "quotaUser", valid_598017
  var valid_598018 = query.getOrDefault("alt")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = newJString("json"))
  if valid_598018 != nil:
    section.add "alt", valid_598018
  var valid_598019 = query.getOrDefault("oauth_token")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "oauth_token", valid_598019
  var valid_598020 = query.getOrDefault("userIp")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "userIp", valid_598020
  var valid_598021 = query.getOrDefault("maxResults")
  valid_598021 = validateParameter(valid_598021, JInt, required = false, default = nil)
  if valid_598021 != nil:
    section.add "maxResults", valid_598021
  var valid_598022 = query.getOrDefault("key")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = nil)
  if valid_598022 != nil:
    section.add "key", valid_598022
  var valid_598023 = query.getOrDefault("prettyPrint")
  valid_598023 = validateParameter(valid_598023, JBool, required = false,
                                 default = newJBool(true))
  if valid_598023 != nil:
    section.add "prettyPrint", valid_598023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598024: Call_AdexchangesellerAdunitsCustomchannelsList_598010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_598024.validator(path, query, header, formData, body)
  let scheme = call_598024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598024.url(scheme.get, call_598024.host, call_598024.base,
                         call_598024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598024, url, valid)

proc call*(call_598025: Call_AdexchangesellerAdunitsCustomchannelsList_598010;
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
  var path_598026 = newJObject()
  var query_598027 = newJObject()
  add(query_598027, "fields", newJString(fields))
  add(query_598027, "pageToken", newJString(pageToken))
  add(query_598027, "quotaUser", newJString(quotaUser))
  add(query_598027, "alt", newJString(alt))
  add(query_598027, "oauth_token", newJString(oauthToken))
  add(query_598027, "userIp", newJString(userIp))
  add(query_598027, "maxResults", newJInt(maxResults))
  add(query_598027, "key", newJString(key))
  add(path_598026, "adClientId", newJString(adClientId))
  add(path_598026, "adUnitId", newJString(adUnitId))
  add(query_598027, "prettyPrint", newJBool(prettyPrint))
  result = call_598025.call(path_598026, query_598027, nil, nil, nil)

var adexchangesellerAdunitsCustomchannelsList* = Call_AdexchangesellerAdunitsCustomchannelsList_598010(
    name: "adexchangesellerAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdexchangesellerAdunitsCustomchannelsList_598011,
    base: "/adexchangeseller/v1",
    url: url_AdexchangesellerAdunitsCustomchannelsList_598012,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsList_598028 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerCustomchannelsList_598030(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerCustomchannelsList_598029(path: JsonNode;
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
  var valid_598031 = path.getOrDefault("adClientId")
  valid_598031 = validateParameter(valid_598031, JString, required = true,
                                 default = nil)
  if valid_598031 != nil:
    section.add "adClientId", valid_598031
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
  var valid_598032 = query.getOrDefault("fields")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "fields", valid_598032
  var valid_598033 = query.getOrDefault("pageToken")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "pageToken", valid_598033
  var valid_598034 = query.getOrDefault("quotaUser")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "quotaUser", valid_598034
  var valid_598035 = query.getOrDefault("alt")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = newJString("json"))
  if valid_598035 != nil:
    section.add "alt", valid_598035
  var valid_598036 = query.getOrDefault("oauth_token")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "oauth_token", valid_598036
  var valid_598037 = query.getOrDefault("userIp")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "userIp", valid_598037
  var valid_598038 = query.getOrDefault("maxResults")
  valid_598038 = validateParameter(valid_598038, JInt, required = false, default = nil)
  if valid_598038 != nil:
    section.add "maxResults", valid_598038
  var valid_598039 = query.getOrDefault("key")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "key", valid_598039
  var valid_598040 = query.getOrDefault("prettyPrint")
  valid_598040 = validateParameter(valid_598040, JBool, required = false,
                                 default = newJBool(true))
  if valid_598040 != nil:
    section.add "prettyPrint", valid_598040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598041: Call_AdexchangesellerCustomchannelsList_598028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_598041.validator(path, query, header, formData, body)
  let scheme = call_598041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598041.url(scheme.get, call_598041.host, call_598041.base,
                         call_598041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598041, url, valid)

proc call*(call_598042: Call_AdexchangesellerCustomchannelsList_598028;
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
  var path_598043 = newJObject()
  var query_598044 = newJObject()
  add(query_598044, "fields", newJString(fields))
  add(query_598044, "pageToken", newJString(pageToken))
  add(query_598044, "quotaUser", newJString(quotaUser))
  add(query_598044, "alt", newJString(alt))
  add(query_598044, "oauth_token", newJString(oauthToken))
  add(query_598044, "userIp", newJString(userIp))
  add(query_598044, "maxResults", newJInt(maxResults))
  add(query_598044, "key", newJString(key))
  add(path_598043, "adClientId", newJString(adClientId))
  add(query_598044, "prettyPrint", newJBool(prettyPrint))
  result = call_598042.call(path_598043, query_598044, nil, nil, nil)

var adexchangesellerCustomchannelsList* = Call_AdexchangesellerCustomchannelsList_598028(
    name: "adexchangesellerCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdexchangesellerCustomchannelsList_598029,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerCustomchannelsList_598030,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsGet_598045 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerCustomchannelsGet_598047(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerCustomchannelsGet_598046(path: JsonNode;
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
  var valid_598048 = path.getOrDefault("customChannelId")
  valid_598048 = validateParameter(valid_598048, JString, required = true,
                                 default = nil)
  if valid_598048 != nil:
    section.add "customChannelId", valid_598048
  var valid_598049 = path.getOrDefault("adClientId")
  valid_598049 = validateParameter(valid_598049, JString, required = true,
                                 default = nil)
  if valid_598049 != nil:
    section.add "adClientId", valid_598049
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
  var valid_598050 = query.getOrDefault("fields")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "fields", valid_598050
  var valid_598051 = query.getOrDefault("quotaUser")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "quotaUser", valid_598051
  var valid_598052 = query.getOrDefault("alt")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = newJString("json"))
  if valid_598052 != nil:
    section.add "alt", valid_598052
  var valid_598053 = query.getOrDefault("oauth_token")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "oauth_token", valid_598053
  var valid_598054 = query.getOrDefault("userIp")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "userIp", valid_598054
  var valid_598055 = query.getOrDefault("key")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "key", valid_598055
  var valid_598056 = query.getOrDefault("prettyPrint")
  valid_598056 = validateParameter(valid_598056, JBool, required = false,
                                 default = newJBool(true))
  if valid_598056 != nil:
    section.add "prettyPrint", valid_598056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598057: Call_AdexchangesellerCustomchannelsGet_598045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_598057.validator(path, query, header, formData, body)
  let scheme = call_598057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598057.url(scheme.get, call_598057.host, call_598057.base,
                         call_598057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598057, url, valid)

proc call*(call_598058: Call_AdexchangesellerCustomchannelsGet_598045;
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
  var path_598059 = newJObject()
  var query_598060 = newJObject()
  add(query_598060, "fields", newJString(fields))
  add(query_598060, "quotaUser", newJString(quotaUser))
  add(query_598060, "alt", newJString(alt))
  add(query_598060, "oauth_token", newJString(oauthToken))
  add(path_598059, "customChannelId", newJString(customChannelId))
  add(query_598060, "userIp", newJString(userIp))
  add(query_598060, "key", newJString(key))
  add(path_598059, "adClientId", newJString(adClientId))
  add(query_598060, "prettyPrint", newJBool(prettyPrint))
  result = call_598058.call(path_598059, query_598060, nil, nil, nil)

var adexchangesellerCustomchannelsGet* = Call_AdexchangesellerCustomchannelsGet_598045(
    name: "adexchangesellerCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdexchangesellerCustomchannelsGet_598046,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerCustomchannelsGet_598047,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsAdunitsList_598061 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerCustomchannelsAdunitsList_598063(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerCustomchannelsAdunitsList_598062(path: JsonNode;
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
  var valid_598064 = path.getOrDefault("customChannelId")
  valid_598064 = validateParameter(valid_598064, JString, required = true,
                                 default = nil)
  if valid_598064 != nil:
    section.add "customChannelId", valid_598064
  var valid_598065 = path.getOrDefault("adClientId")
  valid_598065 = validateParameter(valid_598065, JString, required = true,
                                 default = nil)
  if valid_598065 != nil:
    section.add "adClientId", valid_598065
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
  var valid_598066 = query.getOrDefault("fields")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = nil)
  if valid_598066 != nil:
    section.add "fields", valid_598066
  var valid_598067 = query.getOrDefault("pageToken")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "pageToken", valid_598067
  var valid_598068 = query.getOrDefault("quotaUser")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "quotaUser", valid_598068
  var valid_598069 = query.getOrDefault("alt")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = newJString("json"))
  if valid_598069 != nil:
    section.add "alt", valid_598069
  var valid_598070 = query.getOrDefault("includeInactive")
  valid_598070 = validateParameter(valid_598070, JBool, required = false, default = nil)
  if valid_598070 != nil:
    section.add "includeInactive", valid_598070
  var valid_598071 = query.getOrDefault("oauth_token")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "oauth_token", valid_598071
  var valid_598072 = query.getOrDefault("userIp")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "userIp", valid_598072
  var valid_598073 = query.getOrDefault("maxResults")
  valid_598073 = validateParameter(valid_598073, JInt, required = false, default = nil)
  if valid_598073 != nil:
    section.add "maxResults", valid_598073
  var valid_598074 = query.getOrDefault("key")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "key", valid_598074
  var valid_598075 = query.getOrDefault("prettyPrint")
  valid_598075 = validateParameter(valid_598075, JBool, required = false,
                                 default = newJBool(true))
  if valid_598075 != nil:
    section.add "prettyPrint", valid_598075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598076: Call_AdexchangesellerCustomchannelsAdunitsList_598061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_598076.validator(path, query, header, formData, body)
  let scheme = call_598076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598076.url(scheme.get, call_598076.host, call_598076.base,
                         call_598076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598076, url, valid)

proc call*(call_598077: Call_AdexchangesellerCustomchannelsAdunitsList_598061;
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
  var path_598078 = newJObject()
  var query_598079 = newJObject()
  add(query_598079, "fields", newJString(fields))
  add(query_598079, "pageToken", newJString(pageToken))
  add(query_598079, "quotaUser", newJString(quotaUser))
  add(query_598079, "alt", newJString(alt))
  add(query_598079, "includeInactive", newJBool(includeInactive))
  add(query_598079, "oauth_token", newJString(oauthToken))
  add(path_598078, "customChannelId", newJString(customChannelId))
  add(query_598079, "userIp", newJString(userIp))
  add(query_598079, "maxResults", newJInt(maxResults))
  add(query_598079, "key", newJString(key))
  add(path_598078, "adClientId", newJString(adClientId))
  add(query_598079, "prettyPrint", newJBool(prettyPrint))
  result = call_598077.call(path_598078, query_598079, nil, nil, nil)

var adexchangesellerCustomchannelsAdunitsList* = Call_AdexchangesellerCustomchannelsAdunitsList_598061(
    name: "adexchangesellerCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdexchangesellerCustomchannelsAdunitsList_598062,
    base: "/adexchangeseller/v1",
    url: url_AdexchangesellerCustomchannelsAdunitsList_598063,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerUrlchannelsList_598080 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerUrlchannelsList_598082(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerUrlchannelsList_598081(path: JsonNode;
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
  var valid_598083 = path.getOrDefault("adClientId")
  valid_598083 = validateParameter(valid_598083, JString, required = true,
                                 default = nil)
  if valid_598083 != nil:
    section.add "adClientId", valid_598083
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
  var valid_598084 = query.getOrDefault("fields")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = nil)
  if valid_598084 != nil:
    section.add "fields", valid_598084
  var valid_598085 = query.getOrDefault("pageToken")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "pageToken", valid_598085
  var valid_598086 = query.getOrDefault("quotaUser")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "quotaUser", valid_598086
  var valid_598087 = query.getOrDefault("alt")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = newJString("json"))
  if valid_598087 != nil:
    section.add "alt", valid_598087
  var valid_598088 = query.getOrDefault("oauth_token")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = nil)
  if valid_598088 != nil:
    section.add "oauth_token", valid_598088
  var valid_598089 = query.getOrDefault("userIp")
  valid_598089 = validateParameter(valid_598089, JString, required = false,
                                 default = nil)
  if valid_598089 != nil:
    section.add "userIp", valid_598089
  var valid_598090 = query.getOrDefault("maxResults")
  valid_598090 = validateParameter(valid_598090, JInt, required = false, default = nil)
  if valid_598090 != nil:
    section.add "maxResults", valid_598090
  var valid_598091 = query.getOrDefault("key")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "key", valid_598091
  var valid_598092 = query.getOrDefault("prettyPrint")
  valid_598092 = validateParameter(valid_598092, JBool, required = false,
                                 default = newJBool(true))
  if valid_598092 != nil:
    section.add "prettyPrint", valid_598092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598093: Call_AdexchangesellerUrlchannelsList_598080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_598093.validator(path, query, header, formData, body)
  let scheme = call_598093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598093.url(scheme.get, call_598093.host, call_598093.base,
                         call_598093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598093, url, valid)

proc call*(call_598094: Call_AdexchangesellerUrlchannelsList_598080;
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
  var path_598095 = newJObject()
  var query_598096 = newJObject()
  add(query_598096, "fields", newJString(fields))
  add(query_598096, "pageToken", newJString(pageToken))
  add(query_598096, "quotaUser", newJString(quotaUser))
  add(query_598096, "alt", newJString(alt))
  add(query_598096, "oauth_token", newJString(oauthToken))
  add(query_598096, "userIp", newJString(userIp))
  add(query_598096, "maxResults", newJInt(maxResults))
  add(query_598096, "key", newJString(key))
  add(path_598095, "adClientId", newJString(adClientId))
  add(query_598096, "prettyPrint", newJBool(prettyPrint))
  result = call_598094.call(path_598095, query_598096, nil, nil, nil)

var adexchangesellerUrlchannelsList* = Call_AdexchangesellerUrlchannelsList_598080(
    name: "adexchangesellerUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdexchangesellerUrlchannelsList_598081,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerUrlchannelsList_598082,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsGenerate_598097 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerReportsGenerate_598099(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangesellerReportsGenerate_598098(path: JsonNode;
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
  var valid_598100 = query.getOrDefault("locale")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "locale", valid_598100
  var valid_598101 = query.getOrDefault("fields")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "fields", valid_598101
  var valid_598102 = query.getOrDefault("quotaUser")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "quotaUser", valid_598102
  var valid_598103 = query.getOrDefault("alt")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = newJString("json"))
  if valid_598103 != nil:
    section.add "alt", valid_598103
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_598104 = query.getOrDefault("endDate")
  valid_598104 = validateParameter(valid_598104, JString, required = true,
                                 default = nil)
  if valid_598104 != nil:
    section.add "endDate", valid_598104
  var valid_598105 = query.getOrDefault("startDate")
  valid_598105 = validateParameter(valid_598105, JString, required = true,
                                 default = nil)
  if valid_598105 != nil:
    section.add "startDate", valid_598105
  var valid_598106 = query.getOrDefault("sort")
  valid_598106 = validateParameter(valid_598106, JArray, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "sort", valid_598106
  var valid_598107 = query.getOrDefault("oauth_token")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "oauth_token", valid_598107
  var valid_598108 = query.getOrDefault("userIp")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = nil)
  if valid_598108 != nil:
    section.add "userIp", valid_598108
  var valid_598109 = query.getOrDefault("maxResults")
  valid_598109 = validateParameter(valid_598109, JInt, required = false, default = nil)
  if valid_598109 != nil:
    section.add "maxResults", valid_598109
  var valid_598110 = query.getOrDefault("key")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "key", valid_598110
  var valid_598111 = query.getOrDefault("metric")
  valid_598111 = validateParameter(valid_598111, JArray, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "metric", valid_598111
  var valid_598112 = query.getOrDefault("prettyPrint")
  valid_598112 = validateParameter(valid_598112, JBool, required = false,
                                 default = newJBool(true))
  if valid_598112 != nil:
    section.add "prettyPrint", valid_598112
  var valid_598113 = query.getOrDefault("dimension")
  valid_598113 = validateParameter(valid_598113, JArray, required = false,
                                 default = nil)
  if valid_598113 != nil:
    section.add "dimension", valid_598113
  var valid_598114 = query.getOrDefault("filter")
  valid_598114 = validateParameter(valid_598114, JArray, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "filter", valid_598114
  var valid_598115 = query.getOrDefault("startIndex")
  valid_598115 = validateParameter(valid_598115, JInt, required = false, default = nil)
  if valid_598115 != nil:
    section.add "startIndex", valid_598115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598116: Call_AdexchangesellerReportsGenerate_598097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_598116.validator(path, query, header, formData, body)
  let scheme = call_598116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598116.url(scheme.get, call_598116.host, call_598116.base,
                         call_598116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598116, url, valid)

proc call*(call_598117: Call_AdexchangesellerReportsGenerate_598097;
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
  var query_598118 = newJObject()
  add(query_598118, "locale", newJString(locale))
  add(query_598118, "fields", newJString(fields))
  add(query_598118, "quotaUser", newJString(quotaUser))
  add(query_598118, "alt", newJString(alt))
  add(query_598118, "endDate", newJString(endDate))
  add(query_598118, "startDate", newJString(startDate))
  if sort != nil:
    query_598118.add "sort", sort
  add(query_598118, "oauth_token", newJString(oauthToken))
  add(query_598118, "userIp", newJString(userIp))
  add(query_598118, "maxResults", newJInt(maxResults))
  add(query_598118, "key", newJString(key))
  if metric != nil:
    query_598118.add "metric", metric
  add(query_598118, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_598118.add "dimension", dimension
  if filter != nil:
    query_598118.add "filter", filter
  add(query_598118, "startIndex", newJInt(startIndex))
  result = call_598117.call(nil, query_598118, nil, nil, nil)

var adexchangesellerReportsGenerate* = Call_AdexchangesellerReportsGenerate_598097(
    name: "adexchangesellerReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdexchangesellerReportsGenerate_598098,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerReportsGenerate_598099,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsSavedList_598119 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerReportsSavedList_598121(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangesellerReportsSavedList_598120(path: JsonNode;
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
  var valid_598122 = query.getOrDefault("fields")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "fields", valid_598122
  var valid_598123 = query.getOrDefault("pageToken")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "pageToken", valid_598123
  var valid_598124 = query.getOrDefault("quotaUser")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "quotaUser", valid_598124
  var valid_598125 = query.getOrDefault("alt")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = newJString("json"))
  if valid_598125 != nil:
    section.add "alt", valid_598125
  var valid_598126 = query.getOrDefault("oauth_token")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = nil)
  if valid_598126 != nil:
    section.add "oauth_token", valid_598126
  var valid_598127 = query.getOrDefault("userIp")
  valid_598127 = validateParameter(valid_598127, JString, required = false,
                                 default = nil)
  if valid_598127 != nil:
    section.add "userIp", valid_598127
  var valid_598128 = query.getOrDefault("maxResults")
  valid_598128 = validateParameter(valid_598128, JInt, required = false, default = nil)
  if valid_598128 != nil:
    section.add "maxResults", valid_598128
  var valid_598129 = query.getOrDefault("key")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "key", valid_598129
  var valid_598130 = query.getOrDefault("prettyPrint")
  valid_598130 = validateParameter(valid_598130, JBool, required = false,
                                 default = newJBool(true))
  if valid_598130 != nil:
    section.add "prettyPrint", valid_598130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598131: Call_AdexchangesellerReportsSavedList_598119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in this Ad Exchange account.
  ## 
  let valid = call_598131.validator(path, query, header, formData, body)
  let scheme = call_598131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598131.url(scheme.get, call_598131.host, call_598131.base,
                         call_598131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598131, url, valid)

proc call*(call_598132: Call_AdexchangesellerReportsSavedList_598119;
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
  var query_598133 = newJObject()
  add(query_598133, "fields", newJString(fields))
  add(query_598133, "pageToken", newJString(pageToken))
  add(query_598133, "quotaUser", newJString(quotaUser))
  add(query_598133, "alt", newJString(alt))
  add(query_598133, "oauth_token", newJString(oauthToken))
  add(query_598133, "userIp", newJString(userIp))
  add(query_598133, "maxResults", newJInt(maxResults))
  add(query_598133, "key", newJString(key))
  add(query_598133, "prettyPrint", newJBool(prettyPrint))
  result = call_598132.call(nil, query_598133, nil, nil, nil)

var adexchangesellerReportsSavedList* = Call_AdexchangesellerReportsSavedList_598119(
    name: "adexchangesellerReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/saved",
    validator: validate_AdexchangesellerReportsSavedList_598120,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerReportsSavedList_598121,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsSavedGenerate_598134 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerReportsSavedGenerate_598136(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "savedReportId" in path, "`savedReportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "savedReportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerReportsSavedGenerate_598135(path: JsonNode;
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
  var valid_598137 = path.getOrDefault("savedReportId")
  valid_598137 = validateParameter(valid_598137, JString, required = true,
                                 default = nil)
  if valid_598137 != nil:
    section.add "savedReportId", valid_598137
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
  var valid_598138 = query.getOrDefault("locale")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "locale", valid_598138
  var valid_598139 = query.getOrDefault("fields")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "fields", valid_598139
  var valid_598140 = query.getOrDefault("quotaUser")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "quotaUser", valid_598140
  var valid_598141 = query.getOrDefault("alt")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = newJString("json"))
  if valid_598141 != nil:
    section.add "alt", valid_598141
  var valid_598142 = query.getOrDefault("oauth_token")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "oauth_token", valid_598142
  var valid_598143 = query.getOrDefault("userIp")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "userIp", valid_598143
  var valid_598144 = query.getOrDefault("maxResults")
  valid_598144 = validateParameter(valid_598144, JInt, required = false, default = nil)
  if valid_598144 != nil:
    section.add "maxResults", valid_598144
  var valid_598145 = query.getOrDefault("key")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "key", valid_598145
  var valid_598146 = query.getOrDefault("prettyPrint")
  valid_598146 = validateParameter(valid_598146, JBool, required = false,
                                 default = newJBool(true))
  if valid_598146 != nil:
    section.add "prettyPrint", valid_598146
  var valid_598147 = query.getOrDefault("startIndex")
  valid_598147 = validateParameter(valid_598147, JInt, required = false, default = nil)
  if valid_598147 != nil:
    section.add "startIndex", valid_598147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598148: Call_AdexchangesellerReportsSavedGenerate_598134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_598148.validator(path, query, header, formData, body)
  let scheme = call_598148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598148.url(scheme.get, call_598148.host, call_598148.base,
                         call_598148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598148, url, valid)

proc call*(call_598149: Call_AdexchangesellerReportsSavedGenerate_598134;
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
  var path_598150 = newJObject()
  var query_598151 = newJObject()
  add(query_598151, "locale", newJString(locale))
  add(query_598151, "fields", newJString(fields))
  add(query_598151, "quotaUser", newJString(quotaUser))
  add(query_598151, "alt", newJString(alt))
  add(query_598151, "oauth_token", newJString(oauthToken))
  add(query_598151, "userIp", newJString(userIp))
  add(query_598151, "maxResults", newJInt(maxResults))
  add(path_598150, "savedReportId", newJString(savedReportId))
  add(query_598151, "key", newJString(key))
  add(query_598151, "prettyPrint", newJBool(prettyPrint))
  add(query_598151, "startIndex", newJInt(startIndex))
  result = call_598149.call(path_598150, query_598151, nil, nil, nil)

var adexchangesellerReportsSavedGenerate* = Call_AdexchangesellerReportsSavedGenerate_598134(
    name: "adexchangesellerReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{savedReportId}",
    validator: validate_AdexchangesellerReportsSavedGenerate_598135,
    base: "/adexchangeseller/v1", url: url_AdexchangesellerReportsSavedGenerate_598136,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
