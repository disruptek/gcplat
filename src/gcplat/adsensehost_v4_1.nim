
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: AdSense Host
## version: v4.1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Generates performance reports, generates ad codes, and provides publisher management capabilities for AdSense Hosts.
## 
## https://developers.google.com/adsense/host/
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
  gcpServiceName = "adsensehost"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdsensehostAccountsList_579693 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAccountsList_579695(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostAccountsList_579694(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List hosted accounts associated with this AdSense account by ad client id.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   filterAdClientId: JArray (required)
  ##                   : Ad clients to list accounts for.
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
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  assert query != nil,
        "query argument is necessary due to required `filterAdClientId` field"
  var valid_579808 = query.getOrDefault("filterAdClientId")
  valid_579808 = validateParameter(valid_579808, JArray, required = true, default = nil)
  if valid_579808 != nil:
    section.add "filterAdClientId", valid_579808
  var valid_579809 = query.getOrDefault("quotaUser")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "quotaUser", valid_579809
  var valid_579823 = query.getOrDefault("alt")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = newJString("json"))
  if valid_579823 != nil:
    section.add "alt", valid_579823
  var valid_579824 = query.getOrDefault("oauth_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "oauth_token", valid_579824
  var valid_579825 = query.getOrDefault("userIp")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "userIp", valid_579825
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

proc call*(call_579850: Call_AdsensehostAccountsList_579693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List hosted accounts associated with this AdSense account by ad client id.
  ## 
  let valid = call_579850.validator(path, query, header, formData, body)
  let scheme = call_579850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579850.url(scheme.get, call_579850.host, call_579850.base,
                         call_579850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579850, url, valid)

proc call*(call_579921: Call_AdsensehostAccountsList_579693;
          filterAdClientId: JsonNode; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsList
  ## List hosted accounts associated with this AdSense account by ad client id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   filterAdClientId: JArray (required)
  ##                   : Ad clients to list accounts for.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579922 = newJObject()
  add(query_579922, "fields", newJString(fields))
  if filterAdClientId != nil:
    query_579922.add "filterAdClientId", filterAdClientId
  add(query_579922, "quotaUser", newJString(quotaUser))
  add(query_579922, "alt", newJString(alt))
  add(query_579922, "oauth_token", newJString(oauthToken))
  add(query_579922, "userIp", newJString(userIp))
  add(query_579922, "key", newJString(key))
  add(query_579922, "prettyPrint", newJBool(prettyPrint))
  result = call_579921.call(nil, query_579922, nil, nil, nil)

var adsensehostAccountsList* = Call_AdsensehostAccountsList_579693(
    name: "adsensehostAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdsensehostAccountsList_579694, base: "/adsensehost/v4.1",
    url: url_AdsensehostAccountsList_579695, schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsGet_579962 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAccountsGet_579964(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsGet_579963(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about the selected associated AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to get information about.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579979 = path.getOrDefault("accountId")
  valid_579979 = validateParameter(valid_579979, JString, required = true,
                                 default = nil)
  if valid_579979 != nil:
    section.add "accountId", valid_579979
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
  var valid_579980 = query.getOrDefault("fields")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "fields", valid_579980
  var valid_579981 = query.getOrDefault("quotaUser")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "quotaUser", valid_579981
  var valid_579982 = query.getOrDefault("alt")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("json"))
  if valid_579982 != nil:
    section.add "alt", valid_579982
  var valid_579983 = query.getOrDefault("oauth_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "oauth_token", valid_579983
  var valid_579984 = query.getOrDefault("userIp")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "userIp", valid_579984
  var valid_579985 = query.getOrDefault("key")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "key", valid_579985
  var valid_579986 = query.getOrDefault("prettyPrint")
  valid_579986 = validateParameter(valid_579986, JBool, required = false,
                                 default = newJBool(true))
  if valid_579986 != nil:
    section.add "prettyPrint", valid_579986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579987: Call_AdsensehostAccountsGet_579962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected associated AdSense account.
  ## 
  let valid = call_579987.validator(path, query, header, formData, body)
  let scheme = call_579987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579987.url(scheme.get, call_579987.host, call_579987.base,
                         call_579987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579987, url, valid)

proc call*(call_579988: Call_AdsensehostAccountsGet_579962; accountId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsGet
  ## Get information about the selected associated AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to get information about.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579989 = newJObject()
  var query_579990 = newJObject()
  add(query_579990, "fields", newJString(fields))
  add(query_579990, "quotaUser", newJString(quotaUser))
  add(query_579990, "alt", newJString(alt))
  add(query_579990, "oauth_token", newJString(oauthToken))
  add(path_579989, "accountId", newJString(accountId))
  add(query_579990, "userIp", newJString(userIp))
  add(query_579990, "key", newJString(key))
  add(query_579990, "prettyPrint", newJBool(prettyPrint))
  result = call_579988.call(path_579989, query_579990, nil, nil, nil)

var adsensehostAccountsGet* = Call_AdsensehostAccountsGet_579962(
    name: "adsensehostAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdsensehostAccountsGet_579963, base: "/adsensehost/v4.1",
    url: url_AdsensehostAccountsGet_579964, schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdclientsList_579991 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAccountsAdclientsList_579993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsAdclientsList_579992(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all hosted ad clients in the specified hosted account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account for which to list ad clients.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579994 = path.getOrDefault("accountId")
  valid_579994 = validateParameter(valid_579994, JString, required = true,
                                 default = nil)
  if valid_579994 != nil:
    section.add "accountId", valid_579994
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
  var valid_579995 = query.getOrDefault("fields")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "fields", valid_579995
  var valid_579996 = query.getOrDefault("pageToken")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "pageToken", valid_579996
  var valid_579997 = query.getOrDefault("quotaUser")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "quotaUser", valid_579997
  var valid_579998 = query.getOrDefault("alt")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = newJString("json"))
  if valid_579998 != nil:
    section.add "alt", valid_579998
  var valid_579999 = query.getOrDefault("oauth_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "oauth_token", valid_579999
  var valid_580000 = query.getOrDefault("userIp")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "userIp", valid_580000
  var valid_580001 = query.getOrDefault("maxResults")
  valid_580001 = validateParameter(valid_580001, JInt, required = false, default = nil)
  if valid_580001 != nil:
    section.add "maxResults", valid_580001
  var valid_580002 = query.getOrDefault("key")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "key", valid_580002
  var valid_580003 = query.getOrDefault("prettyPrint")
  valid_580003 = validateParameter(valid_580003, JBool, required = false,
                                 default = newJBool(true))
  if valid_580003 != nil:
    section.add "prettyPrint", valid_580003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580004: Call_AdsensehostAccountsAdclientsList_579991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all hosted ad clients in the specified hosted account.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_AdsensehostAccountsAdclientsList_579991;
          accountId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdclientsList
  ## List all hosted ad clients in the specified hosted account.
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
  ##   accountId: string (required)
  ##            : Account for which to list ad clients.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580006 = newJObject()
  var query_580007 = newJObject()
  add(query_580007, "fields", newJString(fields))
  add(query_580007, "pageToken", newJString(pageToken))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(path_580006, "accountId", newJString(accountId))
  add(query_580007, "userIp", newJString(userIp))
  add(query_580007, "maxResults", newJInt(maxResults))
  add(query_580007, "key", newJString(key))
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  result = call_580005.call(path_580006, query_580007, nil, nil, nil)

var adsensehostAccountsAdclientsList* = Call_AdsensehostAccountsAdclientsList_579991(
    name: "adsensehostAccountsAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients",
    validator: validate_AdsensehostAccountsAdclientsList_579992,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdclientsList_579993,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdclientsGet_580008 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAccountsAdclientsGet_580010(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsAdclientsGet_580009(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about one of the ad clients in the specified publisher's AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  ##   adClientId: JString (required)
  ##             : Ad client to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580011 = path.getOrDefault("accountId")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "accountId", valid_580011
  var valid_580012 = path.getOrDefault("adClientId")
  valid_580012 = validateParameter(valid_580012, JString, required = true,
                                 default = nil)
  if valid_580012 != nil:
    section.add "adClientId", valid_580012
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
  var valid_580013 = query.getOrDefault("fields")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "fields", valid_580013
  var valid_580014 = query.getOrDefault("quotaUser")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "quotaUser", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("oauth_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "oauth_token", valid_580016
  var valid_580017 = query.getOrDefault("userIp")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "userIp", valid_580017
  var valid_580018 = query.getOrDefault("key")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "key", valid_580018
  var valid_580019 = query.getOrDefault("prettyPrint")
  valid_580019 = validateParameter(valid_580019, JBool, required = false,
                                 default = newJBool(true))
  if valid_580019 != nil:
    section.add "prettyPrint", valid_580019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580020: Call_AdsensehostAccountsAdclientsGet_580008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about one of the ad clients in the specified publisher's AdSense account.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_AdsensehostAccountsAdclientsGet_580008;
          accountId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdclientsGet
  ## Get information about one of the ad clients in the specified publisher's AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client to get.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580022 = newJObject()
  var query_580023 = newJObject()
  add(query_580023, "fields", newJString(fields))
  add(query_580023, "quotaUser", newJString(quotaUser))
  add(query_580023, "alt", newJString(alt))
  add(query_580023, "oauth_token", newJString(oauthToken))
  add(path_580022, "accountId", newJString(accountId))
  add(query_580023, "userIp", newJString(userIp))
  add(query_580023, "key", newJString(key))
  add(path_580022, "adClientId", newJString(adClientId))
  add(query_580023, "prettyPrint", newJBool(prettyPrint))
  result = call_580021.call(path_580022, query_580023, nil, nil, nil)

var adsensehostAccountsAdclientsGet* = Call_AdsensehostAccountsAdclientsGet_580008(
    name: "adsensehostAccountsAdclientsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}",
    validator: validate_AdsensehostAccountsAdclientsGet_580009,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdclientsGet_580010,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsUpdate_580043 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAccountsAdunitsUpdate_580045(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsAdunitsUpdate_580044(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the supplied ad unit in the specified publisher AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the ad unit.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580046 = path.getOrDefault("accountId")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "accountId", valid_580046
  var valid_580047 = path.getOrDefault("adClientId")
  valid_580047 = validateParameter(valid_580047, JString, required = true,
                                 default = nil)
  if valid_580047 != nil:
    section.add "adClientId", valid_580047
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
  var valid_580048 = query.getOrDefault("fields")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "fields", valid_580048
  var valid_580049 = query.getOrDefault("quotaUser")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "quotaUser", valid_580049
  var valid_580050 = query.getOrDefault("alt")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("json"))
  if valid_580050 != nil:
    section.add "alt", valid_580050
  var valid_580051 = query.getOrDefault("oauth_token")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "oauth_token", valid_580051
  var valid_580052 = query.getOrDefault("userIp")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "userIp", valid_580052
  var valid_580053 = query.getOrDefault("key")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "key", valid_580053
  var valid_580054 = query.getOrDefault("prettyPrint")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(true))
  if valid_580054 != nil:
    section.add "prettyPrint", valid_580054
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

proc call*(call_580056: Call_AdsensehostAccountsAdunitsUpdate_580043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the supplied ad unit in the specified publisher AdSense account.
  ## 
  let valid = call_580056.validator(path, query, header, formData, body)
  let scheme = call_580056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580056.url(scheme.get, call_580056.host, call_580056.base,
                         call_580056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580056, url, valid)

proc call*(call_580057: Call_AdsensehostAccountsAdunitsUpdate_580043;
          accountId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsUpdate
  ## Update the supplied ad unit in the specified publisher AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the ad unit.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580058 = newJObject()
  var query_580059 = newJObject()
  var body_580060 = newJObject()
  add(query_580059, "fields", newJString(fields))
  add(query_580059, "quotaUser", newJString(quotaUser))
  add(query_580059, "alt", newJString(alt))
  add(query_580059, "oauth_token", newJString(oauthToken))
  add(path_580058, "accountId", newJString(accountId))
  add(query_580059, "userIp", newJString(userIp))
  add(query_580059, "key", newJString(key))
  add(path_580058, "adClientId", newJString(adClientId))
  if body != nil:
    body_580060 = body
  add(query_580059, "prettyPrint", newJBool(prettyPrint))
  result = call_580057.call(path_580058, query_580059, nil, nil, body_580060)

var adsensehostAccountsAdunitsUpdate* = Call_AdsensehostAccountsAdunitsUpdate_580043(
    name: "adsensehostAccountsAdunitsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsUpdate_580044,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsUpdate_580045,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsInsert_580061 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAccountsAdunitsInsert_580063(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsAdunitsInsert_580062(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Insert the supplied ad unit into the specified publisher AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which will contain the ad unit.
  ##   adClientId: JString (required)
  ##             : Ad client into which to insert the ad unit.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580064 = path.getOrDefault("accountId")
  valid_580064 = validateParameter(valid_580064, JString, required = true,
                                 default = nil)
  if valid_580064 != nil:
    section.add "accountId", valid_580064
  var valid_580065 = path.getOrDefault("adClientId")
  valid_580065 = validateParameter(valid_580065, JString, required = true,
                                 default = nil)
  if valid_580065 != nil:
    section.add "adClientId", valid_580065
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
  var valid_580066 = query.getOrDefault("fields")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "fields", valid_580066
  var valid_580067 = query.getOrDefault("quotaUser")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "quotaUser", valid_580067
  var valid_580068 = query.getOrDefault("alt")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = newJString("json"))
  if valid_580068 != nil:
    section.add "alt", valid_580068
  var valid_580069 = query.getOrDefault("oauth_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "oauth_token", valid_580069
  var valid_580070 = query.getOrDefault("userIp")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "userIp", valid_580070
  var valid_580071 = query.getOrDefault("key")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "key", valid_580071
  var valid_580072 = query.getOrDefault("prettyPrint")
  valid_580072 = validateParameter(valid_580072, JBool, required = false,
                                 default = newJBool(true))
  if valid_580072 != nil:
    section.add "prettyPrint", valid_580072
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

proc call*(call_580074: Call_AdsensehostAccountsAdunitsInsert_580061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert the supplied ad unit into the specified publisher AdSense account.
  ## 
  let valid = call_580074.validator(path, query, header, formData, body)
  let scheme = call_580074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580074.url(scheme.get, call_580074.host, call_580074.base,
                         call_580074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580074, url, valid)

proc call*(call_580075: Call_AdsensehostAccountsAdunitsInsert_580061;
          accountId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsInsert
  ## Insert the supplied ad unit into the specified publisher AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which will contain the ad unit.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client into which to insert the ad unit.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580076 = newJObject()
  var query_580077 = newJObject()
  var body_580078 = newJObject()
  add(query_580077, "fields", newJString(fields))
  add(query_580077, "quotaUser", newJString(quotaUser))
  add(query_580077, "alt", newJString(alt))
  add(query_580077, "oauth_token", newJString(oauthToken))
  add(path_580076, "accountId", newJString(accountId))
  add(query_580077, "userIp", newJString(userIp))
  add(query_580077, "key", newJString(key))
  add(path_580076, "adClientId", newJString(adClientId))
  if body != nil:
    body_580078 = body
  add(query_580077, "prettyPrint", newJBool(prettyPrint))
  result = call_580075.call(path_580076, query_580077, nil, nil, body_580078)

var adsensehostAccountsAdunitsInsert* = Call_AdsensehostAccountsAdunitsInsert_580061(
    name: "adsensehostAccountsAdunitsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsInsert_580062,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsInsert_580063,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsList_580024 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAccountsAdunitsList_580026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsAdunitsList_580025(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified publisher's AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  ##   adClientId: JString (required)
  ##             : Ad client for which to list ad units.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580027 = path.getOrDefault("accountId")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "accountId", valid_580027
  var valid_580028 = path.getOrDefault("adClientId")
  valid_580028 = validateParameter(valid_580028, JString, required = true,
                                 default = nil)
  if valid_580028 != nil:
    section.add "adClientId", valid_580028
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
  var valid_580029 = query.getOrDefault("fields")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "fields", valid_580029
  var valid_580030 = query.getOrDefault("pageToken")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "pageToken", valid_580030
  var valid_580031 = query.getOrDefault("quotaUser")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "quotaUser", valid_580031
  var valid_580032 = query.getOrDefault("alt")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("json"))
  if valid_580032 != nil:
    section.add "alt", valid_580032
  var valid_580033 = query.getOrDefault("includeInactive")
  valid_580033 = validateParameter(valid_580033, JBool, required = false, default = nil)
  if valid_580033 != nil:
    section.add "includeInactive", valid_580033
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("userIp")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "userIp", valid_580035
  var valid_580036 = query.getOrDefault("maxResults")
  valid_580036 = validateParameter(valid_580036, JInt, required = false, default = nil)
  if valid_580036 != nil:
    section.add "maxResults", valid_580036
  var valid_580037 = query.getOrDefault("key")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "key", valid_580037
  var valid_580038 = query.getOrDefault("prettyPrint")
  valid_580038 = validateParameter(valid_580038, JBool, required = false,
                                 default = newJBool(true))
  if valid_580038 != nil:
    section.add "prettyPrint", valid_580038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580039: Call_AdsensehostAccountsAdunitsList_580024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified publisher's AdSense account.
  ## 
  let valid = call_580039.validator(path, query, header, formData, body)
  let scheme = call_580039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580039.url(scheme.get, call_580039.host, call_580039.base,
                         call_580039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580039, url, valid)

proc call*(call_580040: Call_AdsensehostAccountsAdunitsList_580024;
          accountId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          includeInactive: bool = false; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsList
  ## List all ad units in the specified publisher's AdSense account.
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
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
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
  var path_580041 = newJObject()
  var query_580042 = newJObject()
  add(query_580042, "fields", newJString(fields))
  add(query_580042, "pageToken", newJString(pageToken))
  add(query_580042, "quotaUser", newJString(quotaUser))
  add(query_580042, "alt", newJString(alt))
  add(query_580042, "includeInactive", newJBool(includeInactive))
  add(query_580042, "oauth_token", newJString(oauthToken))
  add(path_580041, "accountId", newJString(accountId))
  add(query_580042, "userIp", newJString(userIp))
  add(query_580042, "maxResults", newJInt(maxResults))
  add(query_580042, "key", newJString(key))
  add(path_580041, "adClientId", newJString(adClientId))
  add(query_580042, "prettyPrint", newJBool(prettyPrint))
  result = call_580040.call(path_580041, query_580042, nil, nil, nil)

var adsensehostAccountsAdunitsList* = Call_AdsensehostAccountsAdunitsList_580024(
    name: "adsensehostAccountsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsList_580025,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsList_580026,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsPatch_580079 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAccountsAdunitsPatch_580081(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsAdunitsPatch_580080(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the supplied ad unit in the specified publisher AdSense account. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the ad unit.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580082 = path.getOrDefault("accountId")
  valid_580082 = validateParameter(valid_580082, JString, required = true,
                                 default = nil)
  if valid_580082 != nil:
    section.add "accountId", valid_580082
  var valid_580083 = path.getOrDefault("adClientId")
  valid_580083 = validateParameter(valid_580083, JString, required = true,
                                 default = nil)
  if valid_580083 != nil:
    section.add "adClientId", valid_580083
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   adUnitId: JString (required)
  ##           : Ad unit to get.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
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
  var valid_580085 = query.getOrDefault("quotaUser")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "quotaUser", valid_580085
  var valid_580086 = query.getOrDefault("alt")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = newJString("json"))
  if valid_580086 != nil:
    section.add "alt", valid_580086
  assert query != nil,
        "query argument is necessary due to required `adUnitId` field"
  var valid_580087 = query.getOrDefault("adUnitId")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "adUnitId", valid_580087
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
  var valid_580090 = query.getOrDefault("key")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "key", valid_580090
  var valid_580091 = query.getOrDefault("prettyPrint")
  valid_580091 = validateParameter(valid_580091, JBool, required = false,
                                 default = newJBool(true))
  if valid_580091 != nil:
    section.add "prettyPrint", valid_580091
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

proc call*(call_580093: Call_AdsensehostAccountsAdunitsPatch_580079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the supplied ad unit in the specified publisher AdSense account. This method supports patch semantics.
  ## 
  let valid = call_580093.validator(path, query, header, formData, body)
  let scheme = call_580093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580093.url(scheme.get, call_580093.host, call_580093.base,
                         call_580093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580093, url, valid)

proc call*(call_580094: Call_AdsensehostAccountsAdunitsPatch_580079;
          adUnitId: string; accountId: string; adClientId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsPatch
  ## Update the supplied ad unit in the specified publisher AdSense account. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   adUnitId: string (required)
  ##           : Ad unit to get.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the ad unit.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580095 = newJObject()
  var query_580096 = newJObject()
  var body_580097 = newJObject()
  add(query_580096, "fields", newJString(fields))
  add(query_580096, "quotaUser", newJString(quotaUser))
  add(query_580096, "alt", newJString(alt))
  add(query_580096, "adUnitId", newJString(adUnitId))
  add(query_580096, "oauth_token", newJString(oauthToken))
  add(path_580095, "accountId", newJString(accountId))
  add(query_580096, "userIp", newJString(userIp))
  add(query_580096, "key", newJString(key))
  add(path_580095, "adClientId", newJString(adClientId))
  if body != nil:
    body_580097 = body
  add(query_580096, "prettyPrint", newJBool(prettyPrint))
  result = call_580094.call(path_580095, query_580096, nil, nil, body_580097)

var adsensehostAccountsAdunitsPatch* = Call_AdsensehostAccountsAdunitsPatch_580079(
    name: "adsensehostAccountsAdunitsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsPatch_580080,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsPatch_580081,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsGet_580098 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAccountsAdunitsGet_580100(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsAdunitsGet_580099(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified host ad unit in this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad unit.
  ##   adClientId: JString (required)
  ##             : Ad client for which to get ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580101 = path.getOrDefault("accountId")
  valid_580101 = validateParameter(valid_580101, JString, required = true,
                                 default = nil)
  if valid_580101 != nil:
    section.add "accountId", valid_580101
  var valid_580102 = path.getOrDefault("adClientId")
  valid_580102 = validateParameter(valid_580102, JString, required = true,
                                 default = nil)
  if valid_580102 != nil:
    section.add "adClientId", valid_580102
  var valid_580103 = path.getOrDefault("adUnitId")
  valid_580103 = validateParameter(valid_580103, JString, required = true,
                                 default = nil)
  if valid_580103 != nil:
    section.add "adUnitId", valid_580103
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
  var valid_580104 = query.getOrDefault("fields")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "fields", valid_580104
  var valid_580105 = query.getOrDefault("quotaUser")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "quotaUser", valid_580105
  var valid_580106 = query.getOrDefault("alt")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = newJString("json"))
  if valid_580106 != nil:
    section.add "alt", valid_580106
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
  var valid_580109 = query.getOrDefault("key")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "key", valid_580109
  var valid_580110 = query.getOrDefault("prettyPrint")
  valid_580110 = validateParameter(valid_580110, JBool, required = false,
                                 default = newJBool(true))
  if valid_580110 != nil:
    section.add "prettyPrint", valid_580110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580111: Call_AdsensehostAccountsAdunitsGet_580098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified host ad unit in this AdSense account.
  ## 
  let valid = call_580111.validator(path, query, header, formData, body)
  let scheme = call_580111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580111.url(scheme.get, call_580111.host, call_580111.base,
                         call_580111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580111, url, valid)

proc call*(call_580112: Call_AdsensehostAccountsAdunitsGet_580098;
          accountId: string; adClientId: string; adUnitId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsGet
  ## Get the specified host ad unit in this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad unit.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to get ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580113 = newJObject()
  var query_580114 = newJObject()
  add(query_580114, "fields", newJString(fields))
  add(query_580114, "quotaUser", newJString(quotaUser))
  add(query_580114, "alt", newJString(alt))
  add(query_580114, "oauth_token", newJString(oauthToken))
  add(path_580113, "accountId", newJString(accountId))
  add(query_580114, "userIp", newJString(userIp))
  add(query_580114, "key", newJString(key))
  add(path_580113, "adClientId", newJString(adClientId))
  add(path_580113, "adUnitId", newJString(adUnitId))
  add(query_580114, "prettyPrint", newJBool(prettyPrint))
  result = call_580112.call(path_580113, query_580114, nil, nil, nil)

var adsensehostAccountsAdunitsGet* = Call_AdsensehostAccountsAdunitsGet_580098(
    name: "adsensehostAccountsAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsensehostAccountsAdunitsGet_580099,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsGet_580100,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsDelete_580115 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAccountsAdunitsDelete_580117(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsAdunitsDelete_580116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified ad unit from the specified publisher AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad unit.
  ##   adClientId: JString (required)
  ##             : Ad client for which to get ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580118 = path.getOrDefault("accountId")
  valid_580118 = validateParameter(valid_580118, JString, required = true,
                                 default = nil)
  if valid_580118 != nil:
    section.add "accountId", valid_580118
  var valid_580119 = path.getOrDefault("adClientId")
  valid_580119 = validateParameter(valid_580119, JString, required = true,
                                 default = nil)
  if valid_580119 != nil:
    section.add "adClientId", valid_580119
  var valid_580120 = path.getOrDefault("adUnitId")
  valid_580120 = validateParameter(valid_580120, JString, required = true,
                                 default = nil)
  if valid_580120 != nil:
    section.add "adUnitId", valid_580120
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
  var valid_580121 = query.getOrDefault("fields")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "fields", valid_580121
  var valid_580122 = query.getOrDefault("quotaUser")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "quotaUser", valid_580122
  var valid_580123 = query.getOrDefault("alt")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = newJString("json"))
  if valid_580123 != nil:
    section.add "alt", valid_580123
  var valid_580124 = query.getOrDefault("oauth_token")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "oauth_token", valid_580124
  var valid_580125 = query.getOrDefault("userIp")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "userIp", valid_580125
  var valid_580126 = query.getOrDefault("key")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "key", valid_580126
  var valid_580127 = query.getOrDefault("prettyPrint")
  valid_580127 = validateParameter(valid_580127, JBool, required = false,
                                 default = newJBool(true))
  if valid_580127 != nil:
    section.add "prettyPrint", valid_580127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580128: Call_AdsensehostAccountsAdunitsDelete_580115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the specified ad unit from the specified publisher AdSense account.
  ## 
  let valid = call_580128.validator(path, query, header, formData, body)
  let scheme = call_580128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580128.url(scheme.get, call_580128.host, call_580128.base,
                         call_580128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580128, url, valid)

proc call*(call_580129: Call_AdsensehostAccountsAdunitsDelete_580115;
          accountId: string; adClientId: string; adUnitId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsDelete
  ## Delete the specified ad unit from the specified publisher AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad unit.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to get ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to delete.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580130 = newJObject()
  var query_580131 = newJObject()
  add(query_580131, "fields", newJString(fields))
  add(query_580131, "quotaUser", newJString(quotaUser))
  add(query_580131, "alt", newJString(alt))
  add(query_580131, "oauth_token", newJString(oauthToken))
  add(path_580130, "accountId", newJString(accountId))
  add(query_580131, "userIp", newJString(userIp))
  add(query_580131, "key", newJString(key))
  add(path_580130, "adClientId", newJString(adClientId))
  add(path_580130, "adUnitId", newJString(adUnitId))
  add(query_580131, "prettyPrint", newJBool(prettyPrint))
  result = call_580129.call(path_580130, query_580131, nil, nil, nil)

var adsensehostAccountsAdunitsDelete* = Call_AdsensehostAccountsAdunitsDelete_580115(
    name: "adsensehostAccountsAdunitsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsensehostAccountsAdunitsDelete_580116,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsDelete_580117,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsGetAdCode_580132 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAccountsAdunitsGetAdCode_580134(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId"),
               (kind: ConstantSegment, value: "/adcode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsAdunitsGetAdCode_580133(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get ad code for the specified ad unit, attaching the specified host custom channels.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  ##   adClientId: JString (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to get the code for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580135 = path.getOrDefault("accountId")
  valid_580135 = validateParameter(valid_580135, JString, required = true,
                                 default = nil)
  if valid_580135 != nil:
    section.add "accountId", valid_580135
  var valid_580136 = path.getOrDefault("adClientId")
  valid_580136 = validateParameter(valid_580136, JString, required = true,
                                 default = nil)
  if valid_580136 != nil:
    section.add "adClientId", valid_580136
  var valid_580137 = path.getOrDefault("adUnitId")
  valid_580137 = validateParameter(valid_580137, JString, required = true,
                                 default = nil)
  if valid_580137 != nil:
    section.add "adUnitId", valid_580137
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   hostCustomChannelId: JArray
  ##                      : Host custom channel to attach to the ad code.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580138 = query.getOrDefault("fields")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "fields", valid_580138
  var valid_580139 = query.getOrDefault("quotaUser")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "quotaUser", valid_580139
  var valid_580140 = query.getOrDefault("alt")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("json"))
  if valid_580140 != nil:
    section.add "alt", valid_580140
  var valid_580141 = query.getOrDefault("hostCustomChannelId")
  valid_580141 = validateParameter(valid_580141, JArray, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "hostCustomChannelId", valid_580141
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
  var valid_580144 = query.getOrDefault("key")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "key", valid_580144
  var valid_580145 = query.getOrDefault("prettyPrint")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "prettyPrint", valid_580145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580146: Call_AdsensehostAccountsAdunitsGetAdCode_580132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit, attaching the specified host custom channels.
  ## 
  let valid = call_580146.validator(path, query, header, formData, body)
  let scheme = call_580146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580146.url(scheme.get, call_580146.host, call_580146.base,
                         call_580146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580146, url, valid)

proc call*(call_580147: Call_AdsensehostAccountsAdunitsGetAdCode_580132;
          accountId: string; adClientId: string; adUnitId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          hostCustomChannelId: JsonNode = nil; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAccountsAdunitsGetAdCode
  ## Get ad code for the specified ad unit, attaching the specified host custom channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   hostCustomChannelId: JArray
  ##                      : Host custom channel to attach to the ad code.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get the code for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580148 = newJObject()
  var query_580149 = newJObject()
  add(query_580149, "fields", newJString(fields))
  add(query_580149, "quotaUser", newJString(quotaUser))
  add(query_580149, "alt", newJString(alt))
  if hostCustomChannelId != nil:
    query_580149.add "hostCustomChannelId", hostCustomChannelId
  add(query_580149, "oauth_token", newJString(oauthToken))
  add(path_580148, "accountId", newJString(accountId))
  add(query_580149, "userIp", newJString(userIp))
  add(query_580149, "key", newJString(key))
  add(path_580148, "adClientId", newJString(adClientId))
  add(path_580148, "adUnitId", newJString(adUnitId))
  add(query_580149, "prettyPrint", newJBool(prettyPrint))
  result = call_580147.call(path_580148, query_580149, nil, nil, nil)

var adsensehostAccountsAdunitsGetAdCode* = Call_AdsensehostAccountsAdunitsGetAdCode_580132(
    name: "adsensehostAccountsAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsensehostAccountsAdunitsGetAdCode_580133,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsGetAdCode_580134,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsReportsGenerate_580150 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAccountsReportsGenerate_580152(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/reports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsReportsGenerate_580151(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Hosted account upon which to report.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580153 = path.getOrDefault("accountId")
  valid_580153 = validateParameter(valid_580153, JString, required = true,
                                 default = nil)
  if valid_580153 != nil:
    section.add "accountId", valid_580153
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
  var valid_580154 = query.getOrDefault("locale")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "locale", valid_580154
  var valid_580155 = query.getOrDefault("fields")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "fields", valid_580155
  var valid_580156 = query.getOrDefault("quotaUser")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "quotaUser", valid_580156
  var valid_580157 = query.getOrDefault("alt")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = newJString("json"))
  if valid_580157 != nil:
    section.add "alt", valid_580157
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_580158 = query.getOrDefault("endDate")
  valid_580158 = validateParameter(valid_580158, JString, required = true,
                                 default = nil)
  if valid_580158 != nil:
    section.add "endDate", valid_580158
  var valid_580159 = query.getOrDefault("startDate")
  valid_580159 = validateParameter(valid_580159, JString, required = true,
                                 default = nil)
  if valid_580159 != nil:
    section.add "startDate", valid_580159
  var valid_580160 = query.getOrDefault("sort")
  valid_580160 = validateParameter(valid_580160, JArray, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "sort", valid_580160
  var valid_580161 = query.getOrDefault("oauth_token")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "oauth_token", valid_580161
  var valid_580162 = query.getOrDefault("userIp")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "userIp", valid_580162
  var valid_580163 = query.getOrDefault("maxResults")
  valid_580163 = validateParameter(valid_580163, JInt, required = false, default = nil)
  if valid_580163 != nil:
    section.add "maxResults", valid_580163
  var valid_580164 = query.getOrDefault("key")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "key", valid_580164
  var valid_580165 = query.getOrDefault("metric")
  valid_580165 = validateParameter(valid_580165, JArray, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "metric", valid_580165
  var valid_580166 = query.getOrDefault("prettyPrint")
  valid_580166 = validateParameter(valid_580166, JBool, required = false,
                                 default = newJBool(true))
  if valid_580166 != nil:
    section.add "prettyPrint", valid_580166
  var valid_580167 = query.getOrDefault("dimension")
  valid_580167 = validateParameter(valid_580167, JArray, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "dimension", valid_580167
  var valid_580168 = query.getOrDefault("filter")
  valid_580168 = validateParameter(valid_580168, JArray, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "filter", valid_580168
  var valid_580169 = query.getOrDefault("startIndex")
  valid_580169 = validateParameter(valid_580169, JInt, required = false, default = nil)
  if valid_580169 != nil:
    section.add "startIndex", valid_580169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580170: Call_AdsensehostAccountsReportsGenerate_580150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_580170.validator(path, query, header, formData, body)
  let scheme = call_580170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580170.url(scheme.get, call_580170.host, call_580170.base,
                         call_580170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580170, url, valid)

proc call*(call_580171: Call_AdsensehostAccountsReportsGenerate_580150;
          endDate: string; startDate: string; accountId: string; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          sort: JsonNode = nil; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; metric: JsonNode = nil;
          prettyPrint: bool = true; dimension: JsonNode = nil; filter: JsonNode = nil;
          startIndex: int = 0): Recallable =
  ## adsensehostAccountsReportsGenerate
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
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
  ##   accountId: string (required)
  ##            : Hosted account upon which to report.
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
  var path_580172 = newJObject()
  var query_580173 = newJObject()
  add(query_580173, "locale", newJString(locale))
  add(query_580173, "fields", newJString(fields))
  add(query_580173, "quotaUser", newJString(quotaUser))
  add(query_580173, "alt", newJString(alt))
  add(query_580173, "endDate", newJString(endDate))
  add(query_580173, "startDate", newJString(startDate))
  if sort != nil:
    query_580173.add "sort", sort
  add(query_580173, "oauth_token", newJString(oauthToken))
  add(path_580172, "accountId", newJString(accountId))
  add(query_580173, "userIp", newJString(userIp))
  add(query_580173, "maxResults", newJInt(maxResults))
  add(query_580173, "key", newJString(key))
  if metric != nil:
    query_580173.add "metric", metric
  add(query_580173, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_580173.add "dimension", dimension
  if filter != nil:
    query_580173.add "filter", filter
  add(query_580173, "startIndex", newJInt(startIndex))
  result = call_580171.call(path_580172, query_580173, nil, nil, nil)

var adsensehostAccountsReportsGenerate* = Call_AdsensehostAccountsReportsGenerate_580150(
    name: "adsensehostAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdsensehostAccountsReportsGenerate_580151,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsReportsGenerate_580152,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAdclientsList_580174 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAdclientsList_580176(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostAdclientsList_580175(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all host ad clients in this AdSense account.
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
  var valid_580177 = query.getOrDefault("fields")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "fields", valid_580177
  var valid_580178 = query.getOrDefault("pageToken")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "pageToken", valid_580178
  var valid_580179 = query.getOrDefault("quotaUser")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "quotaUser", valid_580179
  var valid_580180 = query.getOrDefault("alt")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = newJString("json"))
  if valid_580180 != nil:
    section.add "alt", valid_580180
  var valid_580181 = query.getOrDefault("oauth_token")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "oauth_token", valid_580181
  var valid_580182 = query.getOrDefault("userIp")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "userIp", valid_580182
  var valid_580183 = query.getOrDefault("maxResults")
  valid_580183 = validateParameter(valid_580183, JInt, required = false, default = nil)
  if valid_580183 != nil:
    section.add "maxResults", valid_580183
  var valid_580184 = query.getOrDefault("key")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "key", valid_580184
  var valid_580185 = query.getOrDefault("prettyPrint")
  valid_580185 = validateParameter(valid_580185, JBool, required = false,
                                 default = newJBool(true))
  if valid_580185 != nil:
    section.add "prettyPrint", valid_580185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580186: Call_AdsensehostAdclientsList_580174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all host ad clients in this AdSense account.
  ## 
  let valid = call_580186.validator(path, query, header, formData, body)
  let scheme = call_580186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580186.url(scheme.get, call_580186.host, call_580186.base,
                         call_580186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580186, url, valid)

proc call*(call_580187: Call_AdsensehostAdclientsList_580174; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAdclientsList
  ## List all host ad clients in this AdSense account.
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
  var query_580188 = newJObject()
  add(query_580188, "fields", newJString(fields))
  add(query_580188, "pageToken", newJString(pageToken))
  add(query_580188, "quotaUser", newJString(quotaUser))
  add(query_580188, "alt", newJString(alt))
  add(query_580188, "oauth_token", newJString(oauthToken))
  add(query_580188, "userIp", newJString(userIp))
  add(query_580188, "maxResults", newJInt(maxResults))
  add(query_580188, "key", newJString(key))
  add(query_580188, "prettyPrint", newJBool(prettyPrint))
  result = call_580187.call(nil, query_580188, nil, nil, nil)

var adsensehostAdclientsList* = Call_AdsensehostAdclientsList_580174(
    name: "adsensehostAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdsensehostAdclientsList_580175,
    base: "/adsensehost/v4.1", url: url_AdsensehostAdclientsList_580176,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAdclientsGet_580189 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAdclientsGet_580191(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAdclientsGet_580190(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about one of the ad clients in the Host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580192 = path.getOrDefault("adClientId")
  valid_580192 = validateParameter(valid_580192, JString, required = true,
                                 default = nil)
  if valid_580192 != nil:
    section.add "adClientId", valid_580192
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
  var valid_580193 = query.getOrDefault("fields")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "fields", valid_580193
  var valid_580194 = query.getOrDefault("quotaUser")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "quotaUser", valid_580194
  var valid_580195 = query.getOrDefault("alt")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = newJString("json"))
  if valid_580195 != nil:
    section.add "alt", valid_580195
  var valid_580196 = query.getOrDefault("oauth_token")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "oauth_token", valid_580196
  var valid_580197 = query.getOrDefault("userIp")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "userIp", valid_580197
  var valid_580198 = query.getOrDefault("key")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "key", valid_580198
  var valid_580199 = query.getOrDefault("prettyPrint")
  valid_580199 = validateParameter(valid_580199, JBool, required = false,
                                 default = newJBool(true))
  if valid_580199 != nil:
    section.add "prettyPrint", valid_580199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580200: Call_AdsensehostAdclientsGet_580189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about one of the ad clients in the Host AdSense account.
  ## 
  let valid = call_580200.validator(path, query, header, formData, body)
  let scheme = call_580200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580200.url(scheme.get, call_580200.host, call_580200.base,
                         call_580200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580200, url, valid)

proc call*(call_580201: Call_AdsensehostAdclientsGet_580189; adClientId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsensehostAdclientsGet
  ## Get information about one of the ad clients in the Host AdSense account.
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
  ##             : Ad client to get.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580202 = newJObject()
  var query_580203 = newJObject()
  add(query_580203, "fields", newJString(fields))
  add(query_580203, "quotaUser", newJString(quotaUser))
  add(query_580203, "alt", newJString(alt))
  add(query_580203, "oauth_token", newJString(oauthToken))
  add(query_580203, "userIp", newJString(userIp))
  add(query_580203, "key", newJString(key))
  add(path_580202, "adClientId", newJString(adClientId))
  add(query_580203, "prettyPrint", newJBool(prettyPrint))
  result = call_580201.call(path_580202, query_580203, nil, nil, nil)

var adsensehostAdclientsGet* = Call_AdsensehostAdclientsGet_580189(
    name: "adsensehostAdclientsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}",
    validator: validate_AdsensehostAdclientsGet_580190, base: "/adsensehost/v4.1",
    url: url_AdsensehostAdclientsGet_580191, schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsUpdate_580221 = ref object of OpenApiRestCall_579424
proc url_AdsensehostCustomchannelsUpdate_580223(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsUpdate_580222(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a custom channel in the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client in which the custom channel will be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580224 = path.getOrDefault("adClientId")
  valid_580224 = validateParameter(valid_580224, JString, required = true,
                                 default = nil)
  if valid_580224 != nil:
    section.add "adClientId", valid_580224
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
  var valid_580225 = query.getOrDefault("fields")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "fields", valid_580225
  var valid_580226 = query.getOrDefault("quotaUser")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "quotaUser", valid_580226
  var valid_580227 = query.getOrDefault("alt")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("json"))
  if valid_580227 != nil:
    section.add "alt", valid_580227
  var valid_580228 = query.getOrDefault("oauth_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "oauth_token", valid_580228
  var valid_580229 = query.getOrDefault("userIp")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "userIp", valid_580229
  var valid_580230 = query.getOrDefault("key")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "key", valid_580230
  var valid_580231 = query.getOrDefault("prettyPrint")
  valid_580231 = validateParameter(valid_580231, JBool, required = false,
                                 default = newJBool(true))
  if valid_580231 != nil:
    section.add "prettyPrint", valid_580231
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

proc call*(call_580233: Call_AdsensehostCustomchannelsUpdate_580221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a custom channel in the host AdSense account.
  ## 
  let valid = call_580233.validator(path, query, header, formData, body)
  let scheme = call_580233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580233.url(scheme.get, call_580233.host, call_580233.base,
                         call_580233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580233, url, valid)

proc call*(call_580234: Call_AdsensehostCustomchannelsUpdate_580221;
          adClientId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adsensehostCustomchannelsUpdate
  ## Update a custom channel in the host AdSense account.
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
  ##             : Ad client in which the custom channel will be updated.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580235 = newJObject()
  var query_580236 = newJObject()
  var body_580237 = newJObject()
  add(query_580236, "fields", newJString(fields))
  add(query_580236, "quotaUser", newJString(quotaUser))
  add(query_580236, "alt", newJString(alt))
  add(query_580236, "oauth_token", newJString(oauthToken))
  add(query_580236, "userIp", newJString(userIp))
  add(query_580236, "key", newJString(key))
  add(path_580235, "adClientId", newJString(adClientId))
  if body != nil:
    body_580237 = body
  add(query_580236, "prettyPrint", newJBool(prettyPrint))
  result = call_580234.call(path_580235, query_580236, nil, nil, body_580237)

var adsensehostCustomchannelsUpdate* = Call_AdsensehostCustomchannelsUpdate_580221(
    name: "adsensehostCustomchannelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsUpdate_580222,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsUpdate_580223,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsInsert_580238 = ref object of OpenApiRestCall_579424
proc url_AdsensehostCustomchannelsInsert_580240(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsInsert_580239(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new custom channel to the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client to which the new custom channel will be added.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580241 = path.getOrDefault("adClientId")
  valid_580241 = validateParameter(valid_580241, JString, required = true,
                                 default = nil)
  if valid_580241 != nil:
    section.add "adClientId", valid_580241
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
  var valid_580242 = query.getOrDefault("fields")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "fields", valid_580242
  var valid_580243 = query.getOrDefault("quotaUser")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "quotaUser", valid_580243
  var valid_580244 = query.getOrDefault("alt")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("json"))
  if valid_580244 != nil:
    section.add "alt", valid_580244
  var valid_580245 = query.getOrDefault("oauth_token")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "oauth_token", valid_580245
  var valid_580246 = query.getOrDefault("userIp")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "userIp", valid_580246
  var valid_580247 = query.getOrDefault("key")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "key", valid_580247
  var valid_580248 = query.getOrDefault("prettyPrint")
  valid_580248 = validateParameter(valid_580248, JBool, required = false,
                                 default = newJBool(true))
  if valid_580248 != nil:
    section.add "prettyPrint", valid_580248
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

proc call*(call_580250: Call_AdsensehostCustomchannelsInsert_580238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a new custom channel to the host AdSense account.
  ## 
  let valid = call_580250.validator(path, query, header, formData, body)
  let scheme = call_580250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580250.url(scheme.get, call_580250.host, call_580250.base,
                         call_580250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580250, url, valid)

proc call*(call_580251: Call_AdsensehostCustomchannelsInsert_580238;
          adClientId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adsensehostCustomchannelsInsert
  ## Add a new custom channel to the host AdSense account.
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
  ##             : Ad client to which the new custom channel will be added.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580252 = newJObject()
  var query_580253 = newJObject()
  var body_580254 = newJObject()
  add(query_580253, "fields", newJString(fields))
  add(query_580253, "quotaUser", newJString(quotaUser))
  add(query_580253, "alt", newJString(alt))
  add(query_580253, "oauth_token", newJString(oauthToken))
  add(query_580253, "userIp", newJString(userIp))
  add(query_580253, "key", newJString(key))
  add(path_580252, "adClientId", newJString(adClientId))
  if body != nil:
    body_580254 = body
  add(query_580253, "prettyPrint", newJBool(prettyPrint))
  result = call_580251.call(path_580252, query_580253, nil, nil, body_580254)

var adsensehostCustomchannelsInsert* = Call_AdsensehostCustomchannelsInsert_580238(
    name: "adsensehostCustomchannelsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsInsert_580239,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsInsert_580240,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsList_580204 = ref object of OpenApiRestCall_579424
proc url_AdsensehostCustomchannelsList_580206(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsList_580205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all host custom channels in this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list custom channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580207 = path.getOrDefault("adClientId")
  valid_580207 = validateParameter(valid_580207, JString, required = true,
                                 default = nil)
  if valid_580207 != nil:
    section.add "adClientId", valid_580207
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
  var valid_580208 = query.getOrDefault("fields")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "fields", valid_580208
  var valid_580209 = query.getOrDefault("pageToken")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "pageToken", valid_580209
  var valid_580210 = query.getOrDefault("quotaUser")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "quotaUser", valid_580210
  var valid_580211 = query.getOrDefault("alt")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("json"))
  if valid_580211 != nil:
    section.add "alt", valid_580211
  var valid_580212 = query.getOrDefault("oauth_token")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "oauth_token", valid_580212
  var valid_580213 = query.getOrDefault("userIp")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "userIp", valid_580213
  var valid_580214 = query.getOrDefault("maxResults")
  valid_580214 = validateParameter(valid_580214, JInt, required = false, default = nil)
  if valid_580214 != nil:
    section.add "maxResults", valid_580214
  var valid_580215 = query.getOrDefault("key")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "key", valid_580215
  var valid_580216 = query.getOrDefault("prettyPrint")
  valid_580216 = validateParameter(valid_580216, JBool, required = false,
                                 default = newJBool(true))
  if valid_580216 != nil:
    section.add "prettyPrint", valid_580216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580217: Call_AdsensehostCustomchannelsList_580204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all host custom channels in this AdSense account.
  ## 
  let valid = call_580217.validator(path, query, header, formData, body)
  let scheme = call_580217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580217.url(scheme.get, call_580217.host, call_580217.base,
                         call_580217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580217, url, valid)

proc call*(call_580218: Call_AdsensehostCustomchannelsList_580204;
          adClientId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsensehostCustomchannelsList
  ## List all host custom channels in this AdSense account.
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
  var path_580219 = newJObject()
  var query_580220 = newJObject()
  add(query_580220, "fields", newJString(fields))
  add(query_580220, "pageToken", newJString(pageToken))
  add(query_580220, "quotaUser", newJString(quotaUser))
  add(query_580220, "alt", newJString(alt))
  add(query_580220, "oauth_token", newJString(oauthToken))
  add(query_580220, "userIp", newJString(userIp))
  add(query_580220, "maxResults", newJInt(maxResults))
  add(query_580220, "key", newJString(key))
  add(path_580219, "adClientId", newJString(adClientId))
  add(query_580220, "prettyPrint", newJBool(prettyPrint))
  result = call_580218.call(path_580219, query_580220, nil, nil, nil)

var adsensehostCustomchannelsList* = Call_AdsensehostCustomchannelsList_580204(
    name: "adsensehostCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsList_580205,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsList_580206,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsPatch_580255 = ref object of OpenApiRestCall_579424
proc url_AdsensehostCustomchannelsPatch_580257(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsPatch_580256(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a custom channel in the host AdSense account. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client in which the custom channel will be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580258 = path.getOrDefault("adClientId")
  valid_580258 = validateParameter(valid_580258, JString, required = true,
                                 default = nil)
  if valid_580258 != nil:
    section.add "adClientId", valid_580258
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   customChannelId: JString (required)
  ##                  : Custom channel to get.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580259 = query.getOrDefault("fields")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "fields", valid_580259
  var valid_580260 = query.getOrDefault("quotaUser")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "quotaUser", valid_580260
  var valid_580261 = query.getOrDefault("alt")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("json"))
  if valid_580261 != nil:
    section.add "alt", valid_580261
  assert query != nil,
        "query argument is necessary due to required `customChannelId` field"
  var valid_580262 = query.getOrDefault("customChannelId")
  valid_580262 = validateParameter(valid_580262, JString, required = true,
                                 default = nil)
  if valid_580262 != nil:
    section.add "customChannelId", valid_580262
  var valid_580263 = query.getOrDefault("oauth_token")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "oauth_token", valid_580263
  var valid_580264 = query.getOrDefault("userIp")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "userIp", valid_580264
  var valid_580265 = query.getOrDefault("key")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "key", valid_580265
  var valid_580266 = query.getOrDefault("prettyPrint")
  valid_580266 = validateParameter(valid_580266, JBool, required = false,
                                 default = newJBool(true))
  if valid_580266 != nil:
    section.add "prettyPrint", valid_580266
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

proc call*(call_580268: Call_AdsensehostCustomchannelsPatch_580255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a custom channel in the host AdSense account. This method supports patch semantics.
  ## 
  let valid = call_580268.validator(path, query, header, formData, body)
  let scheme = call_580268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580268.url(scheme.get, call_580268.host, call_580268.base,
                         call_580268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580268, url, valid)

proc call*(call_580269: Call_AdsensehostCustomchannelsPatch_580255;
          customChannelId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## adsensehostCustomchannelsPatch
  ## Update a custom channel in the host AdSense account. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   customChannelId: string (required)
  ##                  : Custom channel to get.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client in which the custom channel will be updated.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580270 = newJObject()
  var query_580271 = newJObject()
  var body_580272 = newJObject()
  add(query_580271, "fields", newJString(fields))
  add(query_580271, "quotaUser", newJString(quotaUser))
  add(query_580271, "alt", newJString(alt))
  add(query_580271, "customChannelId", newJString(customChannelId))
  add(query_580271, "oauth_token", newJString(oauthToken))
  add(query_580271, "userIp", newJString(userIp))
  add(query_580271, "key", newJString(key))
  add(path_580270, "adClientId", newJString(adClientId))
  if body != nil:
    body_580272 = body
  add(query_580271, "prettyPrint", newJBool(prettyPrint))
  result = call_580269.call(path_580270, query_580271, nil, nil, body_580272)

var adsensehostCustomchannelsPatch* = Call_AdsensehostCustomchannelsPatch_580255(
    name: "adsensehostCustomchannelsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsPatch_580256,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsPatch_580257,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsGet_580273 = ref object of OpenApiRestCall_579424
proc url_AdsensehostCustomchannelsGet_580275(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsGet_580274(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific custom channel from the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customChannelId: JString (required)
  ##                  : Custom channel to get.
  ##   adClientId: JString (required)
  ##             : Ad client from which to get the custom channel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customChannelId` field"
  var valid_580276 = path.getOrDefault("customChannelId")
  valid_580276 = validateParameter(valid_580276, JString, required = true,
                                 default = nil)
  if valid_580276 != nil:
    section.add "customChannelId", valid_580276
  var valid_580277 = path.getOrDefault("adClientId")
  valid_580277 = validateParameter(valid_580277, JString, required = true,
                                 default = nil)
  if valid_580277 != nil:
    section.add "adClientId", valid_580277
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
  var valid_580278 = query.getOrDefault("fields")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "fields", valid_580278
  var valid_580279 = query.getOrDefault("quotaUser")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "quotaUser", valid_580279
  var valid_580280 = query.getOrDefault("alt")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = newJString("json"))
  if valid_580280 != nil:
    section.add "alt", valid_580280
  var valid_580281 = query.getOrDefault("oauth_token")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "oauth_token", valid_580281
  var valid_580282 = query.getOrDefault("userIp")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "userIp", valid_580282
  var valid_580283 = query.getOrDefault("key")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "key", valid_580283
  var valid_580284 = query.getOrDefault("prettyPrint")
  valid_580284 = validateParameter(valid_580284, JBool, required = false,
                                 default = newJBool(true))
  if valid_580284 != nil:
    section.add "prettyPrint", valid_580284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580285: Call_AdsensehostCustomchannelsGet_580273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific custom channel from the host AdSense account.
  ## 
  let valid = call_580285.validator(path, query, header, formData, body)
  let scheme = call_580285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580285.url(scheme.get, call_580285.host, call_580285.base,
                         call_580285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580285, url, valid)

proc call*(call_580286: Call_AdsensehostCustomchannelsGet_580273;
          customChannelId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostCustomchannelsGet
  ## Get a specific custom channel from the host AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customChannelId: string (required)
  ##                  : Custom channel to get.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client from which to get the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580287 = newJObject()
  var query_580288 = newJObject()
  add(query_580288, "fields", newJString(fields))
  add(query_580288, "quotaUser", newJString(quotaUser))
  add(query_580288, "alt", newJString(alt))
  add(query_580288, "oauth_token", newJString(oauthToken))
  add(path_580287, "customChannelId", newJString(customChannelId))
  add(query_580288, "userIp", newJString(userIp))
  add(query_580288, "key", newJString(key))
  add(path_580287, "adClientId", newJString(adClientId))
  add(query_580288, "prettyPrint", newJBool(prettyPrint))
  result = call_580286.call(path_580287, query_580288, nil, nil, nil)

var adsensehostCustomchannelsGet* = Call_AdsensehostCustomchannelsGet_580273(
    name: "adsensehostCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsensehostCustomchannelsGet_580274,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsGet_580275,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsDelete_580289 = ref object of OpenApiRestCall_579424
proc url_AdsensehostCustomchannelsDelete_580291(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsDelete_580290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a specific custom channel from the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customChannelId: JString (required)
  ##                  : Custom channel to delete.
  ##   adClientId: JString (required)
  ##             : Ad client from which to delete the custom channel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customChannelId` field"
  var valid_580292 = path.getOrDefault("customChannelId")
  valid_580292 = validateParameter(valid_580292, JString, required = true,
                                 default = nil)
  if valid_580292 != nil:
    section.add "customChannelId", valid_580292
  var valid_580293 = path.getOrDefault("adClientId")
  valid_580293 = validateParameter(valid_580293, JString, required = true,
                                 default = nil)
  if valid_580293 != nil:
    section.add "adClientId", valid_580293
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
  var valid_580294 = query.getOrDefault("fields")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "fields", valid_580294
  var valid_580295 = query.getOrDefault("quotaUser")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "quotaUser", valid_580295
  var valid_580296 = query.getOrDefault("alt")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = newJString("json"))
  if valid_580296 != nil:
    section.add "alt", valid_580296
  var valid_580297 = query.getOrDefault("oauth_token")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "oauth_token", valid_580297
  var valid_580298 = query.getOrDefault("userIp")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "userIp", valid_580298
  var valid_580299 = query.getOrDefault("key")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "key", valid_580299
  var valid_580300 = query.getOrDefault("prettyPrint")
  valid_580300 = validateParameter(valid_580300, JBool, required = false,
                                 default = newJBool(true))
  if valid_580300 != nil:
    section.add "prettyPrint", valid_580300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580301: Call_AdsensehostCustomchannelsDelete_580289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a specific custom channel from the host AdSense account.
  ## 
  let valid = call_580301.validator(path, query, header, formData, body)
  let scheme = call_580301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580301.url(scheme.get, call_580301.host, call_580301.base,
                         call_580301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580301, url, valid)

proc call*(call_580302: Call_AdsensehostCustomchannelsDelete_580289;
          customChannelId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostCustomchannelsDelete
  ## Delete a specific custom channel from the host AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customChannelId: string (required)
  ##                  : Custom channel to delete.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client from which to delete the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580303 = newJObject()
  var query_580304 = newJObject()
  add(query_580304, "fields", newJString(fields))
  add(query_580304, "quotaUser", newJString(quotaUser))
  add(query_580304, "alt", newJString(alt))
  add(query_580304, "oauth_token", newJString(oauthToken))
  add(path_580303, "customChannelId", newJString(customChannelId))
  add(query_580304, "userIp", newJString(userIp))
  add(query_580304, "key", newJString(key))
  add(path_580303, "adClientId", newJString(adClientId))
  add(query_580304, "prettyPrint", newJBool(prettyPrint))
  result = call_580302.call(path_580303, query_580304, nil, nil, nil)

var adsensehostCustomchannelsDelete* = Call_AdsensehostCustomchannelsDelete_580289(
    name: "adsensehostCustomchannelsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsensehostCustomchannelsDelete_580290,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsDelete_580291,
    schemes: {Scheme.Https})
type
  Call_AdsensehostUrlchannelsInsert_580322 = ref object of OpenApiRestCall_579424
proc url_AdsensehostUrlchannelsInsert_580324(protocol: Scheme; host: string;
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

proc validate_AdsensehostUrlchannelsInsert_580323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new URL channel to the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client to which the new URL channel will be added.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580325 = path.getOrDefault("adClientId")
  valid_580325 = validateParameter(valid_580325, JString, required = true,
                                 default = nil)
  if valid_580325 != nil:
    section.add "adClientId", valid_580325
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
  var valid_580326 = query.getOrDefault("fields")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "fields", valid_580326
  var valid_580327 = query.getOrDefault("quotaUser")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "quotaUser", valid_580327
  var valid_580328 = query.getOrDefault("alt")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = newJString("json"))
  if valid_580328 != nil:
    section.add "alt", valid_580328
  var valid_580329 = query.getOrDefault("oauth_token")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "oauth_token", valid_580329
  var valid_580330 = query.getOrDefault("userIp")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "userIp", valid_580330
  var valid_580331 = query.getOrDefault("key")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "key", valid_580331
  var valid_580332 = query.getOrDefault("prettyPrint")
  valid_580332 = validateParameter(valid_580332, JBool, required = false,
                                 default = newJBool(true))
  if valid_580332 != nil:
    section.add "prettyPrint", valid_580332
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

proc call*(call_580334: Call_AdsensehostUrlchannelsInsert_580322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new URL channel to the host AdSense account.
  ## 
  let valid = call_580334.validator(path, query, header, formData, body)
  let scheme = call_580334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580334.url(scheme.get, call_580334.host, call_580334.base,
                         call_580334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580334, url, valid)

proc call*(call_580335: Call_AdsensehostUrlchannelsInsert_580322;
          adClientId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## adsensehostUrlchannelsInsert
  ## Add a new URL channel to the host AdSense account.
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
  ##             : Ad client to which the new URL channel will be added.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580336 = newJObject()
  var query_580337 = newJObject()
  var body_580338 = newJObject()
  add(query_580337, "fields", newJString(fields))
  add(query_580337, "quotaUser", newJString(quotaUser))
  add(query_580337, "alt", newJString(alt))
  add(query_580337, "oauth_token", newJString(oauthToken))
  add(query_580337, "userIp", newJString(userIp))
  add(query_580337, "key", newJString(key))
  add(path_580336, "adClientId", newJString(adClientId))
  if body != nil:
    body_580338 = body
  add(query_580337, "prettyPrint", newJBool(prettyPrint))
  result = call_580335.call(path_580336, query_580337, nil, nil, body_580338)

var adsensehostUrlchannelsInsert* = Call_AdsensehostUrlchannelsInsert_580322(
    name: "adsensehostUrlchannelsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsensehostUrlchannelsInsert_580323,
    base: "/adsensehost/v4.1", url: url_AdsensehostUrlchannelsInsert_580324,
    schemes: {Scheme.Https})
type
  Call_AdsensehostUrlchannelsList_580305 = ref object of OpenApiRestCall_579424
proc url_AdsensehostUrlchannelsList_580307(protocol: Scheme; host: string;
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

proc validate_AdsensehostUrlchannelsList_580306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all host URL channels in the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list URL channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580308 = path.getOrDefault("adClientId")
  valid_580308 = validateParameter(valid_580308, JString, required = true,
                                 default = nil)
  if valid_580308 != nil:
    section.add "adClientId", valid_580308
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
  var valid_580309 = query.getOrDefault("fields")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "fields", valid_580309
  var valid_580310 = query.getOrDefault("pageToken")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "pageToken", valid_580310
  var valid_580311 = query.getOrDefault("quotaUser")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "quotaUser", valid_580311
  var valid_580312 = query.getOrDefault("alt")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = newJString("json"))
  if valid_580312 != nil:
    section.add "alt", valid_580312
  var valid_580313 = query.getOrDefault("oauth_token")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "oauth_token", valid_580313
  var valid_580314 = query.getOrDefault("userIp")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "userIp", valid_580314
  var valid_580315 = query.getOrDefault("maxResults")
  valid_580315 = validateParameter(valid_580315, JInt, required = false, default = nil)
  if valid_580315 != nil:
    section.add "maxResults", valid_580315
  var valid_580316 = query.getOrDefault("key")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "key", valid_580316
  var valid_580317 = query.getOrDefault("prettyPrint")
  valid_580317 = validateParameter(valid_580317, JBool, required = false,
                                 default = newJBool(true))
  if valid_580317 != nil:
    section.add "prettyPrint", valid_580317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580318: Call_AdsensehostUrlchannelsList_580305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all host URL channels in the host AdSense account.
  ## 
  let valid = call_580318.validator(path, query, header, formData, body)
  let scheme = call_580318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580318.url(scheme.get, call_580318.host, call_580318.base,
                         call_580318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580318, url, valid)

proc call*(call_580319: Call_AdsensehostUrlchannelsList_580305; adClientId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostUrlchannelsList
  ## List all host URL channels in the host AdSense account.
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
  var path_580320 = newJObject()
  var query_580321 = newJObject()
  add(query_580321, "fields", newJString(fields))
  add(query_580321, "pageToken", newJString(pageToken))
  add(query_580321, "quotaUser", newJString(quotaUser))
  add(query_580321, "alt", newJString(alt))
  add(query_580321, "oauth_token", newJString(oauthToken))
  add(query_580321, "userIp", newJString(userIp))
  add(query_580321, "maxResults", newJInt(maxResults))
  add(query_580321, "key", newJString(key))
  add(path_580320, "adClientId", newJString(adClientId))
  add(query_580321, "prettyPrint", newJBool(prettyPrint))
  result = call_580319.call(path_580320, query_580321, nil, nil, nil)

var adsensehostUrlchannelsList* = Call_AdsensehostUrlchannelsList_580305(
    name: "adsensehostUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsensehostUrlchannelsList_580306,
    base: "/adsensehost/v4.1", url: url_AdsensehostUrlchannelsList_580307,
    schemes: {Scheme.Https})
type
  Call_AdsensehostUrlchannelsDelete_580339 = ref object of OpenApiRestCall_579424
proc url_AdsensehostUrlchannelsDelete_580341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "urlChannelId" in path, "`urlChannelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/urlchannels/"),
               (kind: VariableSegment, value: "urlChannelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostUrlchannelsDelete_580340(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a URL channel from the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   urlChannelId: JString (required)
  ##               : URL channel to delete.
  ##   adClientId: JString (required)
  ##             : Ad client from which to delete the URL channel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `urlChannelId` field"
  var valid_580342 = path.getOrDefault("urlChannelId")
  valid_580342 = validateParameter(valid_580342, JString, required = true,
                                 default = nil)
  if valid_580342 != nil:
    section.add "urlChannelId", valid_580342
  var valid_580343 = path.getOrDefault("adClientId")
  valid_580343 = validateParameter(valid_580343, JString, required = true,
                                 default = nil)
  if valid_580343 != nil:
    section.add "adClientId", valid_580343
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
  var valid_580344 = query.getOrDefault("fields")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "fields", valid_580344
  var valid_580345 = query.getOrDefault("quotaUser")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "quotaUser", valid_580345
  var valid_580346 = query.getOrDefault("alt")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = newJString("json"))
  if valid_580346 != nil:
    section.add "alt", valid_580346
  var valid_580347 = query.getOrDefault("oauth_token")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "oauth_token", valid_580347
  var valid_580348 = query.getOrDefault("userIp")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "userIp", valid_580348
  var valid_580349 = query.getOrDefault("key")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "key", valid_580349
  var valid_580350 = query.getOrDefault("prettyPrint")
  valid_580350 = validateParameter(valid_580350, JBool, required = false,
                                 default = newJBool(true))
  if valid_580350 != nil:
    section.add "prettyPrint", valid_580350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580351: Call_AdsensehostUrlchannelsDelete_580339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a URL channel from the host AdSense account.
  ## 
  let valid = call_580351.validator(path, query, header, formData, body)
  let scheme = call_580351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580351.url(scheme.get, call_580351.host, call_580351.base,
                         call_580351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580351, url, valid)

proc call*(call_580352: Call_AdsensehostUrlchannelsDelete_580339;
          urlChannelId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostUrlchannelsDelete
  ## Delete a URL channel from the host AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   urlChannelId: string (required)
  ##               : URL channel to delete.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client from which to delete the URL channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580353 = newJObject()
  var query_580354 = newJObject()
  add(query_580354, "fields", newJString(fields))
  add(query_580354, "quotaUser", newJString(quotaUser))
  add(query_580354, "alt", newJString(alt))
  add(path_580353, "urlChannelId", newJString(urlChannelId))
  add(query_580354, "oauth_token", newJString(oauthToken))
  add(query_580354, "userIp", newJString(userIp))
  add(query_580354, "key", newJString(key))
  add(path_580353, "adClientId", newJString(adClientId))
  add(query_580354, "prettyPrint", newJBool(prettyPrint))
  result = call_580352.call(path_580353, query_580354, nil, nil, nil)

var adsensehostUrlchannelsDelete* = Call_AdsensehostUrlchannelsDelete_580339(
    name: "adsensehostUrlchannelsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/urlchannels/{urlChannelId}",
    validator: validate_AdsensehostUrlchannelsDelete_580340,
    base: "/adsensehost/v4.1", url: url_AdsensehostUrlchannelsDelete_580341,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAssociationsessionsStart_580355 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAssociationsessionsStart_580357(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostAssociationsessionsStart_580356(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create an association session for initiating an association with an AdSense user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   websiteLocale: JString
  ##                : The locale of the user's hosted website.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userLocale: JString
  ##             : The preferred locale of the user.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   websiteUrl: JString (required)
  ##             : The URL of the user's hosted website.
  ##   productCode: JArray (required)
  ##              : Products to associate with the user.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580358 = query.getOrDefault("fields")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "fields", valid_580358
  var valid_580359 = query.getOrDefault("quotaUser")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "quotaUser", valid_580359
  var valid_580360 = query.getOrDefault("websiteLocale")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "websiteLocale", valid_580360
  var valid_580361 = query.getOrDefault("alt")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = newJString("json"))
  if valid_580361 != nil:
    section.add "alt", valid_580361
  var valid_580362 = query.getOrDefault("userLocale")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "userLocale", valid_580362
  var valid_580363 = query.getOrDefault("oauth_token")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "oauth_token", valid_580363
  var valid_580364 = query.getOrDefault("userIp")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "userIp", valid_580364
  var valid_580365 = query.getOrDefault("key")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "key", valid_580365
  assert query != nil,
        "query argument is necessary due to required `websiteUrl` field"
  var valid_580366 = query.getOrDefault("websiteUrl")
  valid_580366 = validateParameter(valid_580366, JString, required = true,
                                 default = nil)
  if valid_580366 != nil:
    section.add "websiteUrl", valid_580366
  var valid_580367 = query.getOrDefault("productCode")
  valid_580367 = validateParameter(valid_580367, JArray, required = true, default = nil)
  if valid_580367 != nil:
    section.add "productCode", valid_580367
  var valid_580368 = query.getOrDefault("prettyPrint")
  valid_580368 = validateParameter(valid_580368, JBool, required = false,
                                 default = newJBool(true))
  if valid_580368 != nil:
    section.add "prettyPrint", valid_580368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580369: Call_AdsensehostAssociationsessionsStart_580355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an association session for initiating an association with an AdSense user.
  ## 
  let valid = call_580369.validator(path, query, header, formData, body)
  let scheme = call_580369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580369.url(scheme.get, call_580369.host, call_580369.base,
                         call_580369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580369, url, valid)

proc call*(call_580370: Call_AdsensehostAssociationsessionsStart_580355;
          websiteUrl: string; productCode: JsonNode; fields: string = "";
          quotaUser: string = ""; websiteLocale: string = ""; alt: string = "json";
          userLocale: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAssociationsessionsStart
  ## Create an association session for initiating an association with an AdSense user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   websiteLocale: string
  ##                : The locale of the user's hosted website.
  ##   alt: string
  ##      : Data format for the response.
  ##   userLocale: string
  ##             : The preferred locale of the user.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   websiteUrl: string (required)
  ##             : The URL of the user's hosted website.
  ##   productCode: JArray (required)
  ##              : Products to associate with the user.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580371 = newJObject()
  add(query_580371, "fields", newJString(fields))
  add(query_580371, "quotaUser", newJString(quotaUser))
  add(query_580371, "websiteLocale", newJString(websiteLocale))
  add(query_580371, "alt", newJString(alt))
  add(query_580371, "userLocale", newJString(userLocale))
  add(query_580371, "oauth_token", newJString(oauthToken))
  add(query_580371, "userIp", newJString(userIp))
  add(query_580371, "key", newJString(key))
  add(query_580371, "websiteUrl", newJString(websiteUrl))
  if productCode != nil:
    query_580371.add "productCode", productCode
  add(query_580371, "prettyPrint", newJBool(prettyPrint))
  result = call_580370.call(nil, query_580371, nil, nil, nil)

var adsensehostAssociationsessionsStart* = Call_AdsensehostAssociationsessionsStart_580355(
    name: "adsensehostAssociationsessionsStart", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/associationsessions/start",
    validator: validate_AdsensehostAssociationsessionsStart_580356,
    base: "/adsensehost/v4.1", url: url_AdsensehostAssociationsessionsStart_580357,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAssociationsessionsVerify_580372 = ref object of OpenApiRestCall_579424
proc url_AdsensehostAssociationsessionsVerify_580374(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostAssociationsessionsVerify_580373(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verify an association session after the association callback returns from AdSense signup.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   token: JString (required)
  ##        : The token returned to the association callback URL.
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
  assert query != nil, "query argument is necessary due to required `token` field"
  var valid_580375 = query.getOrDefault("token")
  valid_580375 = validateParameter(valid_580375, JString, required = true,
                                 default = nil)
  if valid_580375 != nil:
    section.add "token", valid_580375
  var valid_580376 = query.getOrDefault("fields")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "fields", valid_580376
  var valid_580377 = query.getOrDefault("quotaUser")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "quotaUser", valid_580377
  var valid_580378 = query.getOrDefault("alt")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = newJString("json"))
  if valid_580378 != nil:
    section.add "alt", valid_580378
  var valid_580379 = query.getOrDefault("oauth_token")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "oauth_token", valid_580379
  var valid_580380 = query.getOrDefault("userIp")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "userIp", valid_580380
  var valid_580381 = query.getOrDefault("key")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "key", valid_580381
  var valid_580382 = query.getOrDefault("prettyPrint")
  valid_580382 = validateParameter(valid_580382, JBool, required = false,
                                 default = newJBool(true))
  if valid_580382 != nil:
    section.add "prettyPrint", valid_580382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580383: Call_AdsensehostAssociationsessionsVerify_580372;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verify an association session after the association callback returns from AdSense signup.
  ## 
  let valid = call_580383.validator(path, query, header, formData, body)
  let scheme = call_580383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580383.url(scheme.get, call_580383.host, call_580383.base,
                         call_580383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580383, url, valid)

proc call*(call_580384: Call_AdsensehostAssociationsessionsVerify_580372;
          token: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensehostAssociationsessionsVerify
  ## Verify an association session after the association callback returns from AdSense signup.
  ##   token: string (required)
  ##        : The token returned to the association callback URL.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580385 = newJObject()
  add(query_580385, "token", newJString(token))
  add(query_580385, "fields", newJString(fields))
  add(query_580385, "quotaUser", newJString(quotaUser))
  add(query_580385, "alt", newJString(alt))
  add(query_580385, "oauth_token", newJString(oauthToken))
  add(query_580385, "userIp", newJString(userIp))
  add(query_580385, "key", newJString(key))
  add(query_580385, "prettyPrint", newJBool(prettyPrint))
  result = call_580384.call(nil, query_580385, nil, nil, nil)

var adsensehostAssociationsessionsVerify* = Call_AdsensehostAssociationsessionsVerify_580372(
    name: "adsensehostAssociationsessionsVerify", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/associationsessions/verify",
    validator: validate_AdsensehostAssociationsessionsVerify_580373,
    base: "/adsensehost/v4.1", url: url_AdsensehostAssociationsessionsVerify_580374,
    schemes: {Scheme.Https})
type
  Call_AdsensehostReportsGenerate_580386 = ref object of OpenApiRestCall_579424
proc url_AdsensehostReportsGenerate_580388(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostReportsGenerate_580387(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
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
  var valid_580389 = query.getOrDefault("locale")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "locale", valid_580389
  var valid_580390 = query.getOrDefault("fields")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "fields", valid_580390
  var valid_580391 = query.getOrDefault("quotaUser")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "quotaUser", valid_580391
  var valid_580392 = query.getOrDefault("alt")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = newJString("json"))
  if valid_580392 != nil:
    section.add "alt", valid_580392
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_580393 = query.getOrDefault("endDate")
  valid_580393 = validateParameter(valid_580393, JString, required = true,
                                 default = nil)
  if valid_580393 != nil:
    section.add "endDate", valid_580393
  var valid_580394 = query.getOrDefault("startDate")
  valid_580394 = validateParameter(valid_580394, JString, required = true,
                                 default = nil)
  if valid_580394 != nil:
    section.add "startDate", valid_580394
  var valid_580395 = query.getOrDefault("sort")
  valid_580395 = validateParameter(valid_580395, JArray, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "sort", valid_580395
  var valid_580396 = query.getOrDefault("oauth_token")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "oauth_token", valid_580396
  var valid_580397 = query.getOrDefault("userIp")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "userIp", valid_580397
  var valid_580398 = query.getOrDefault("maxResults")
  valid_580398 = validateParameter(valid_580398, JInt, required = false, default = nil)
  if valid_580398 != nil:
    section.add "maxResults", valid_580398
  var valid_580399 = query.getOrDefault("key")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "key", valid_580399
  var valid_580400 = query.getOrDefault("metric")
  valid_580400 = validateParameter(valid_580400, JArray, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "metric", valid_580400
  var valid_580401 = query.getOrDefault("prettyPrint")
  valid_580401 = validateParameter(valid_580401, JBool, required = false,
                                 default = newJBool(true))
  if valid_580401 != nil:
    section.add "prettyPrint", valid_580401
  var valid_580402 = query.getOrDefault("dimension")
  valid_580402 = validateParameter(valid_580402, JArray, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "dimension", valid_580402
  var valid_580403 = query.getOrDefault("filter")
  valid_580403 = validateParameter(valid_580403, JArray, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "filter", valid_580403
  var valid_580404 = query.getOrDefault("startIndex")
  valid_580404 = validateParameter(valid_580404, JInt, required = false, default = nil)
  if valid_580404 != nil:
    section.add "startIndex", valid_580404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580405: Call_AdsensehostReportsGenerate_580386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_580405.validator(path, query, header, formData, body)
  let scheme = call_580405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580405.url(scheme.get, call_580405.host, call_580405.base,
                         call_580405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580405, url, valid)

proc call*(call_580406: Call_AdsensehostReportsGenerate_580386; endDate: string;
          startDate: string; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; sort: JsonNode = nil;
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; metric: JsonNode = nil; prettyPrint: bool = true;
          dimension: JsonNode = nil; filter: JsonNode = nil; startIndex: int = 0): Recallable =
  ## adsensehostReportsGenerate
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
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
  var query_580407 = newJObject()
  add(query_580407, "locale", newJString(locale))
  add(query_580407, "fields", newJString(fields))
  add(query_580407, "quotaUser", newJString(quotaUser))
  add(query_580407, "alt", newJString(alt))
  add(query_580407, "endDate", newJString(endDate))
  add(query_580407, "startDate", newJString(startDate))
  if sort != nil:
    query_580407.add "sort", sort
  add(query_580407, "oauth_token", newJString(oauthToken))
  add(query_580407, "userIp", newJString(userIp))
  add(query_580407, "maxResults", newJInt(maxResults))
  add(query_580407, "key", newJString(key))
  if metric != nil:
    query_580407.add "metric", metric
  add(query_580407, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_580407.add "dimension", dimension
  if filter != nil:
    query_580407.add "filter", filter
  add(query_580407, "startIndex", newJInt(startIndex))
  result = call_580406.call(nil, query_580407, nil, nil, nil)

var adsensehostReportsGenerate* = Call_AdsensehostReportsGenerate_580386(
    name: "adsensehostReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdsensehostReportsGenerate_580387,
    base: "/adsensehost/v4.1", url: url_AdsensehostReportsGenerate_580388,
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
