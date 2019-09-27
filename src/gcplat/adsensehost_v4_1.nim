
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "adsensehost"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdsensehostAccountsList_597693 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAccountsList_597695(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsensehostAccountsList_597694(path: JsonNode; query: JsonNode;
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
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  assert query != nil,
        "query argument is necessary due to required `filterAdClientId` field"
  var valid_597808 = query.getOrDefault("filterAdClientId")
  valid_597808 = validateParameter(valid_597808, JArray, required = true, default = nil)
  if valid_597808 != nil:
    section.add "filterAdClientId", valid_597808
  var valid_597809 = query.getOrDefault("quotaUser")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "quotaUser", valid_597809
  var valid_597823 = query.getOrDefault("alt")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = newJString("json"))
  if valid_597823 != nil:
    section.add "alt", valid_597823
  var valid_597824 = query.getOrDefault("oauth_token")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "oauth_token", valid_597824
  var valid_597825 = query.getOrDefault("userIp")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "userIp", valid_597825
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

proc call*(call_597850: Call_AdsensehostAccountsList_597693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List hosted accounts associated with this AdSense account by ad client id.
  ## 
  let valid = call_597850.validator(path, query, header, formData, body)
  let scheme = call_597850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597850.url(scheme.get, call_597850.host, call_597850.base,
                         call_597850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597850, url, valid)

proc call*(call_597921: Call_AdsensehostAccountsList_597693;
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
  var query_597922 = newJObject()
  add(query_597922, "fields", newJString(fields))
  if filterAdClientId != nil:
    query_597922.add "filterAdClientId", filterAdClientId
  add(query_597922, "quotaUser", newJString(quotaUser))
  add(query_597922, "alt", newJString(alt))
  add(query_597922, "oauth_token", newJString(oauthToken))
  add(query_597922, "userIp", newJString(userIp))
  add(query_597922, "key", newJString(key))
  add(query_597922, "prettyPrint", newJBool(prettyPrint))
  result = call_597921.call(nil, query_597922, nil, nil, nil)

var adsensehostAccountsList* = Call_AdsensehostAccountsList_597693(
    name: "adsensehostAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdsensehostAccountsList_597694, base: "/adsensehost/v4.1",
    url: url_AdsensehostAccountsList_597695, schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsGet_597962 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAccountsGet_597964(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsGet_597963(path: JsonNode; query: JsonNode;
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
  var valid_597979 = path.getOrDefault("accountId")
  valid_597979 = validateParameter(valid_597979, JString, required = true,
                                 default = nil)
  if valid_597979 != nil:
    section.add "accountId", valid_597979
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
  var valid_597980 = query.getOrDefault("fields")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "fields", valid_597980
  var valid_597981 = query.getOrDefault("quotaUser")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "quotaUser", valid_597981
  var valid_597982 = query.getOrDefault("alt")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = newJString("json"))
  if valid_597982 != nil:
    section.add "alt", valid_597982
  var valid_597983 = query.getOrDefault("oauth_token")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "oauth_token", valid_597983
  var valid_597984 = query.getOrDefault("userIp")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "userIp", valid_597984
  var valid_597985 = query.getOrDefault("key")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = nil)
  if valid_597985 != nil:
    section.add "key", valid_597985
  var valid_597986 = query.getOrDefault("prettyPrint")
  valid_597986 = validateParameter(valid_597986, JBool, required = false,
                                 default = newJBool(true))
  if valid_597986 != nil:
    section.add "prettyPrint", valid_597986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597987: Call_AdsensehostAccountsGet_597962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected associated AdSense account.
  ## 
  let valid = call_597987.validator(path, query, header, formData, body)
  let scheme = call_597987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597987.url(scheme.get, call_597987.host, call_597987.base,
                         call_597987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597987, url, valid)

proc call*(call_597988: Call_AdsensehostAccountsGet_597962; accountId: string;
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
  var path_597989 = newJObject()
  var query_597990 = newJObject()
  add(query_597990, "fields", newJString(fields))
  add(query_597990, "quotaUser", newJString(quotaUser))
  add(query_597990, "alt", newJString(alt))
  add(query_597990, "oauth_token", newJString(oauthToken))
  add(path_597989, "accountId", newJString(accountId))
  add(query_597990, "userIp", newJString(userIp))
  add(query_597990, "key", newJString(key))
  add(query_597990, "prettyPrint", newJBool(prettyPrint))
  result = call_597988.call(path_597989, query_597990, nil, nil, nil)

var adsensehostAccountsGet* = Call_AdsensehostAccountsGet_597962(
    name: "adsensehostAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdsensehostAccountsGet_597963, base: "/adsensehost/v4.1",
    url: url_AdsensehostAccountsGet_597964, schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdclientsList_597991 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAccountsAdclientsList_597993(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsensehostAccountsAdclientsList_597992(path: JsonNode;
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
  var valid_597994 = path.getOrDefault("accountId")
  valid_597994 = validateParameter(valid_597994, JString, required = true,
                                 default = nil)
  if valid_597994 != nil:
    section.add "accountId", valid_597994
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
  var valid_597995 = query.getOrDefault("fields")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "fields", valid_597995
  var valid_597996 = query.getOrDefault("pageToken")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "pageToken", valid_597996
  var valid_597997 = query.getOrDefault("quotaUser")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "quotaUser", valid_597997
  var valid_597998 = query.getOrDefault("alt")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = newJString("json"))
  if valid_597998 != nil:
    section.add "alt", valid_597998
  var valid_597999 = query.getOrDefault("oauth_token")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "oauth_token", valid_597999
  var valid_598000 = query.getOrDefault("userIp")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "userIp", valid_598000
  var valid_598001 = query.getOrDefault("maxResults")
  valid_598001 = validateParameter(valid_598001, JInt, required = false, default = nil)
  if valid_598001 != nil:
    section.add "maxResults", valid_598001
  var valid_598002 = query.getOrDefault("key")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "key", valid_598002
  var valid_598003 = query.getOrDefault("prettyPrint")
  valid_598003 = validateParameter(valid_598003, JBool, required = false,
                                 default = newJBool(true))
  if valid_598003 != nil:
    section.add "prettyPrint", valid_598003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598004: Call_AdsensehostAccountsAdclientsList_597991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all hosted ad clients in the specified hosted account.
  ## 
  let valid = call_598004.validator(path, query, header, formData, body)
  let scheme = call_598004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598004.url(scheme.get, call_598004.host, call_598004.base,
                         call_598004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598004, url, valid)

proc call*(call_598005: Call_AdsensehostAccountsAdclientsList_597991;
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
  var path_598006 = newJObject()
  var query_598007 = newJObject()
  add(query_598007, "fields", newJString(fields))
  add(query_598007, "pageToken", newJString(pageToken))
  add(query_598007, "quotaUser", newJString(quotaUser))
  add(query_598007, "alt", newJString(alt))
  add(query_598007, "oauth_token", newJString(oauthToken))
  add(path_598006, "accountId", newJString(accountId))
  add(query_598007, "userIp", newJString(userIp))
  add(query_598007, "maxResults", newJInt(maxResults))
  add(query_598007, "key", newJString(key))
  add(query_598007, "prettyPrint", newJBool(prettyPrint))
  result = call_598005.call(path_598006, query_598007, nil, nil, nil)

var adsensehostAccountsAdclientsList* = Call_AdsensehostAccountsAdclientsList_597991(
    name: "adsensehostAccountsAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients",
    validator: validate_AdsensehostAccountsAdclientsList_597992,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdclientsList_597993,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdclientsGet_598008 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAccountsAdclientsGet_598010(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsensehostAccountsAdclientsGet_598009(path: JsonNode;
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
  var valid_598011 = path.getOrDefault("accountId")
  valid_598011 = validateParameter(valid_598011, JString, required = true,
                                 default = nil)
  if valid_598011 != nil:
    section.add "accountId", valid_598011
  var valid_598012 = path.getOrDefault("adClientId")
  valid_598012 = validateParameter(valid_598012, JString, required = true,
                                 default = nil)
  if valid_598012 != nil:
    section.add "adClientId", valid_598012
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
  var valid_598013 = query.getOrDefault("fields")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "fields", valid_598013
  var valid_598014 = query.getOrDefault("quotaUser")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "quotaUser", valid_598014
  var valid_598015 = query.getOrDefault("alt")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = newJString("json"))
  if valid_598015 != nil:
    section.add "alt", valid_598015
  var valid_598016 = query.getOrDefault("oauth_token")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "oauth_token", valid_598016
  var valid_598017 = query.getOrDefault("userIp")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "userIp", valid_598017
  var valid_598018 = query.getOrDefault("key")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "key", valid_598018
  var valid_598019 = query.getOrDefault("prettyPrint")
  valid_598019 = validateParameter(valid_598019, JBool, required = false,
                                 default = newJBool(true))
  if valid_598019 != nil:
    section.add "prettyPrint", valid_598019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598020: Call_AdsensehostAccountsAdclientsGet_598008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about one of the ad clients in the specified publisher's AdSense account.
  ## 
  let valid = call_598020.validator(path, query, header, formData, body)
  let scheme = call_598020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598020.url(scheme.get, call_598020.host, call_598020.base,
                         call_598020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598020, url, valid)

proc call*(call_598021: Call_AdsensehostAccountsAdclientsGet_598008;
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
  var path_598022 = newJObject()
  var query_598023 = newJObject()
  add(query_598023, "fields", newJString(fields))
  add(query_598023, "quotaUser", newJString(quotaUser))
  add(query_598023, "alt", newJString(alt))
  add(query_598023, "oauth_token", newJString(oauthToken))
  add(path_598022, "accountId", newJString(accountId))
  add(query_598023, "userIp", newJString(userIp))
  add(query_598023, "key", newJString(key))
  add(path_598022, "adClientId", newJString(adClientId))
  add(query_598023, "prettyPrint", newJBool(prettyPrint))
  result = call_598021.call(path_598022, query_598023, nil, nil, nil)

var adsensehostAccountsAdclientsGet* = Call_AdsensehostAccountsAdclientsGet_598008(
    name: "adsensehostAccountsAdclientsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}",
    validator: validate_AdsensehostAccountsAdclientsGet_598009,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdclientsGet_598010,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsUpdate_598043 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAccountsAdunitsUpdate_598045(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsensehostAccountsAdunitsUpdate_598044(path: JsonNode;
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
  var valid_598046 = path.getOrDefault("accountId")
  valid_598046 = validateParameter(valid_598046, JString, required = true,
                                 default = nil)
  if valid_598046 != nil:
    section.add "accountId", valid_598046
  var valid_598047 = path.getOrDefault("adClientId")
  valid_598047 = validateParameter(valid_598047, JString, required = true,
                                 default = nil)
  if valid_598047 != nil:
    section.add "adClientId", valid_598047
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
  var valid_598048 = query.getOrDefault("fields")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = nil)
  if valid_598048 != nil:
    section.add "fields", valid_598048
  var valid_598049 = query.getOrDefault("quotaUser")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "quotaUser", valid_598049
  var valid_598050 = query.getOrDefault("alt")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = newJString("json"))
  if valid_598050 != nil:
    section.add "alt", valid_598050
  var valid_598051 = query.getOrDefault("oauth_token")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "oauth_token", valid_598051
  var valid_598052 = query.getOrDefault("userIp")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "userIp", valid_598052
  var valid_598053 = query.getOrDefault("key")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "key", valid_598053
  var valid_598054 = query.getOrDefault("prettyPrint")
  valid_598054 = validateParameter(valid_598054, JBool, required = false,
                                 default = newJBool(true))
  if valid_598054 != nil:
    section.add "prettyPrint", valid_598054
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

proc call*(call_598056: Call_AdsensehostAccountsAdunitsUpdate_598043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the supplied ad unit in the specified publisher AdSense account.
  ## 
  let valid = call_598056.validator(path, query, header, formData, body)
  let scheme = call_598056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598056.url(scheme.get, call_598056.host, call_598056.base,
                         call_598056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598056, url, valid)

proc call*(call_598057: Call_AdsensehostAccountsAdunitsUpdate_598043;
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
  var path_598058 = newJObject()
  var query_598059 = newJObject()
  var body_598060 = newJObject()
  add(query_598059, "fields", newJString(fields))
  add(query_598059, "quotaUser", newJString(quotaUser))
  add(query_598059, "alt", newJString(alt))
  add(query_598059, "oauth_token", newJString(oauthToken))
  add(path_598058, "accountId", newJString(accountId))
  add(query_598059, "userIp", newJString(userIp))
  add(query_598059, "key", newJString(key))
  add(path_598058, "adClientId", newJString(adClientId))
  if body != nil:
    body_598060 = body
  add(query_598059, "prettyPrint", newJBool(prettyPrint))
  result = call_598057.call(path_598058, query_598059, nil, nil, body_598060)

var adsensehostAccountsAdunitsUpdate* = Call_AdsensehostAccountsAdunitsUpdate_598043(
    name: "adsensehostAccountsAdunitsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsUpdate_598044,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsUpdate_598045,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsInsert_598061 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAccountsAdunitsInsert_598063(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsensehostAccountsAdunitsInsert_598062(path: JsonNode;
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
  var valid_598064 = path.getOrDefault("accountId")
  valid_598064 = validateParameter(valid_598064, JString, required = true,
                                 default = nil)
  if valid_598064 != nil:
    section.add "accountId", valid_598064
  var valid_598065 = path.getOrDefault("adClientId")
  valid_598065 = validateParameter(valid_598065, JString, required = true,
                                 default = nil)
  if valid_598065 != nil:
    section.add "adClientId", valid_598065
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
  var valid_598066 = query.getOrDefault("fields")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = nil)
  if valid_598066 != nil:
    section.add "fields", valid_598066
  var valid_598067 = query.getOrDefault("quotaUser")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "quotaUser", valid_598067
  var valid_598068 = query.getOrDefault("alt")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = newJString("json"))
  if valid_598068 != nil:
    section.add "alt", valid_598068
  var valid_598069 = query.getOrDefault("oauth_token")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "oauth_token", valid_598069
  var valid_598070 = query.getOrDefault("userIp")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "userIp", valid_598070
  var valid_598071 = query.getOrDefault("key")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "key", valid_598071
  var valid_598072 = query.getOrDefault("prettyPrint")
  valid_598072 = validateParameter(valid_598072, JBool, required = false,
                                 default = newJBool(true))
  if valid_598072 != nil:
    section.add "prettyPrint", valid_598072
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

proc call*(call_598074: Call_AdsensehostAccountsAdunitsInsert_598061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert the supplied ad unit into the specified publisher AdSense account.
  ## 
  let valid = call_598074.validator(path, query, header, formData, body)
  let scheme = call_598074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598074.url(scheme.get, call_598074.host, call_598074.base,
                         call_598074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598074, url, valid)

proc call*(call_598075: Call_AdsensehostAccountsAdunitsInsert_598061;
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
  var path_598076 = newJObject()
  var query_598077 = newJObject()
  var body_598078 = newJObject()
  add(query_598077, "fields", newJString(fields))
  add(query_598077, "quotaUser", newJString(quotaUser))
  add(query_598077, "alt", newJString(alt))
  add(query_598077, "oauth_token", newJString(oauthToken))
  add(path_598076, "accountId", newJString(accountId))
  add(query_598077, "userIp", newJString(userIp))
  add(query_598077, "key", newJString(key))
  add(path_598076, "adClientId", newJString(adClientId))
  if body != nil:
    body_598078 = body
  add(query_598077, "prettyPrint", newJBool(prettyPrint))
  result = call_598075.call(path_598076, query_598077, nil, nil, body_598078)

var adsensehostAccountsAdunitsInsert* = Call_AdsensehostAccountsAdunitsInsert_598061(
    name: "adsensehostAccountsAdunitsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsInsert_598062,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsInsert_598063,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsList_598024 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAccountsAdunitsList_598026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsensehostAccountsAdunitsList_598025(path: JsonNode;
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
  var valid_598027 = path.getOrDefault("accountId")
  valid_598027 = validateParameter(valid_598027, JString, required = true,
                                 default = nil)
  if valid_598027 != nil:
    section.add "accountId", valid_598027
  var valid_598028 = path.getOrDefault("adClientId")
  valid_598028 = validateParameter(valid_598028, JString, required = true,
                                 default = nil)
  if valid_598028 != nil:
    section.add "adClientId", valid_598028
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
  var valid_598029 = query.getOrDefault("fields")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "fields", valid_598029
  var valid_598030 = query.getOrDefault("pageToken")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "pageToken", valid_598030
  var valid_598031 = query.getOrDefault("quotaUser")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "quotaUser", valid_598031
  var valid_598032 = query.getOrDefault("alt")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = newJString("json"))
  if valid_598032 != nil:
    section.add "alt", valid_598032
  var valid_598033 = query.getOrDefault("includeInactive")
  valid_598033 = validateParameter(valid_598033, JBool, required = false, default = nil)
  if valid_598033 != nil:
    section.add "includeInactive", valid_598033
  var valid_598034 = query.getOrDefault("oauth_token")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "oauth_token", valid_598034
  var valid_598035 = query.getOrDefault("userIp")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "userIp", valid_598035
  var valid_598036 = query.getOrDefault("maxResults")
  valid_598036 = validateParameter(valid_598036, JInt, required = false, default = nil)
  if valid_598036 != nil:
    section.add "maxResults", valid_598036
  var valid_598037 = query.getOrDefault("key")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "key", valid_598037
  var valid_598038 = query.getOrDefault("prettyPrint")
  valid_598038 = validateParameter(valid_598038, JBool, required = false,
                                 default = newJBool(true))
  if valid_598038 != nil:
    section.add "prettyPrint", valid_598038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598039: Call_AdsensehostAccountsAdunitsList_598024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified publisher's AdSense account.
  ## 
  let valid = call_598039.validator(path, query, header, formData, body)
  let scheme = call_598039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598039.url(scheme.get, call_598039.host, call_598039.base,
                         call_598039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598039, url, valid)

proc call*(call_598040: Call_AdsensehostAccountsAdunitsList_598024;
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
  var path_598041 = newJObject()
  var query_598042 = newJObject()
  add(query_598042, "fields", newJString(fields))
  add(query_598042, "pageToken", newJString(pageToken))
  add(query_598042, "quotaUser", newJString(quotaUser))
  add(query_598042, "alt", newJString(alt))
  add(query_598042, "includeInactive", newJBool(includeInactive))
  add(query_598042, "oauth_token", newJString(oauthToken))
  add(path_598041, "accountId", newJString(accountId))
  add(query_598042, "userIp", newJString(userIp))
  add(query_598042, "maxResults", newJInt(maxResults))
  add(query_598042, "key", newJString(key))
  add(path_598041, "adClientId", newJString(adClientId))
  add(query_598042, "prettyPrint", newJBool(prettyPrint))
  result = call_598040.call(path_598041, query_598042, nil, nil, nil)

var adsensehostAccountsAdunitsList* = Call_AdsensehostAccountsAdunitsList_598024(
    name: "adsensehostAccountsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsList_598025,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsList_598026,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsPatch_598079 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAccountsAdunitsPatch_598081(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsensehostAccountsAdunitsPatch_598080(path: JsonNode;
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
  var valid_598082 = path.getOrDefault("accountId")
  valid_598082 = validateParameter(valid_598082, JString, required = true,
                                 default = nil)
  if valid_598082 != nil:
    section.add "accountId", valid_598082
  var valid_598083 = path.getOrDefault("adClientId")
  valid_598083 = validateParameter(valid_598083, JString, required = true,
                                 default = nil)
  if valid_598083 != nil:
    section.add "adClientId", valid_598083
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
  var valid_598084 = query.getOrDefault("fields")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = nil)
  if valid_598084 != nil:
    section.add "fields", valid_598084
  var valid_598085 = query.getOrDefault("quotaUser")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "quotaUser", valid_598085
  var valid_598086 = query.getOrDefault("alt")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = newJString("json"))
  if valid_598086 != nil:
    section.add "alt", valid_598086
  assert query != nil,
        "query argument is necessary due to required `adUnitId` field"
  var valid_598087 = query.getOrDefault("adUnitId")
  valid_598087 = validateParameter(valid_598087, JString, required = true,
                                 default = nil)
  if valid_598087 != nil:
    section.add "adUnitId", valid_598087
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
  var valid_598090 = query.getOrDefault("key")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "key", valid_598090
  var valid_598091 = query.getOrDefault("prettyPrint")
  valid_598091 = validateParameter(valid_598091, JBool, required = false,
                                 default = newJBool(true))
  if valid_598091 != nil:
    section.add "prettyPrint", valid_598091
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

proc call*(call_598093: Call_AdsensehostAccountsAdunitsPatch_598079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the supplied ad unit in the specified publisher AdSense account. This method supports patch semantics.
  ## 
  let valid = call_598093.validator(path, query, header, formData, body)
  let scheme = call_598093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598093.url(scheme.get, call_598093.host, call_598093.base,
                         call_598093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598093, url, valid)

proc call*(call_598094: Call_AdsensehostAccountsAdunitsPatch_598079;
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
  var path_598095 = newJObject()
  var query_598096 = newJObject()
  var body_598097 = newJObject()
  add(query_598096, "fields", newJString(fields))
  add(query_598096, "quotaUser", newJString(quotaUser))
  add(query_598096, "alt", newJString(alt))
  add(query_598096, "adUnitId", newJString(adUnitId))
  add(query_598096, "oauth_token", newJString(oauthToken))
  add(path_598095, "accountId", newJString(accountId))
  add(query_598096, "userIp", newJString(userIp))
  add(query_598096, "key", newJString(key))
  add(path_598095, "adClientId", newJString(adClientId))
  if body != nil:
    body_598097 = body
  add(query_598096, "prettyPrint", newJBool(prettyPrint))
  result = call_598094.call(path_598095, query_598096, nil, nil, body_598097)

var adsensehostAccountsAdunitsPatch* = Call_AdsensehostAccountsAdunitsPatch_598079(
    name: "adsensehostAccountsAdunitsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsPatch_598080,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsPatch_598081,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsGet_598098 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAccountsAdunitsGet_598100(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsensehostAccountsAdunitsGet_598099(path: JsonNode; query: JsonNode;
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
  var valid_598101 = path.getOrDefault("accountId")
  valid_598101 = validateParameter(valid_598101, JString, required = true,
                                 default = nil)
  if valid_598101 != nil:
    section.add "accountId", valid_598101
  var valid_598102 = path.getOrDefault("adClientId")
  valid_598102 = validateParameter(valid_598102, JString, required = true,
                                 default = nil)
  if valid_598102 != nil:
    section.add "adClientId", valid_598102
  var valid_598103 = path.getOrDefault("adUnitId")
  valid_598103 = validateParameter(valid_598103, JString, required = true,
                                 default = nil)
  if valid_598103 != nil:
    section.add "adUnitId", valid_598103
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
  var valid_598104 = query.getOrDefault("fields")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "fields", valid_598104
  var valid_598105 = query.getOrDefault("quotaUser")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = nil)
  if valid_598105 != nil:
    section.add "quotaUser", valid_598105
  var valid_598106 = query.getOrDefault("alt")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = newJString("json"))
  if valid_598106 != nil:
    section.add "alt", valid_598106
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
  var valid_598109 = query.getOrDefault("key")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = nil)
  if valid_598109 != nil:
    section.add "key", valid_598109
  var valid_598110 = query.getOrDefault("prettyPrint")
  valid_598110 = validateParameter(valid_598110, JBool, required = false,
                                 default = newJBool(true))
  if valid_598110 != nil:
    section.add "prettyPrint", valid_598110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598111: Call_AdsensehostAccountsAdunitsGet_598098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified host ad unit in this AdSense account.
  ## 
  let valid = call_598111.validator(path, query, header, formData, body)
  let scheme = call_598111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598111.url(scheme.get, call_598111.host, call_598111.base,
                         call_598111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598111, url, valid)

proc call*(call_598112: Call_AdsensehostAccountsAdunitsGet_598098;
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
  var path_598113 = newJObject()
  var query_598114 = newJObject()
  add(query_598114, "fields", newJString(fields))
  add(query_598114, "quotaUser", newJString(quotaUser))
  add(query_598114, "alt", newJString(alt))
  add(query_598114, "oauth_token", newJString(oauthToken))
  add(path_598113, "accountId", newJString(accountId))
  add(query_598114, "userIp", newJString(userIp))
  add(query_598114, "key", newJString(key))
  add(path_598113, "adClientId", newJString(adClientId))
  add(path_598113, "adUnitId", newJString(adUnitId))
  add(query_598114, "prettyPrint", newJBool(prettyPrint))
  result = call_598112.call(path_598113, query_598114, nil, nil, nil)

var adsensehostAccountsAdunitsGet* = Call_AdsensehostAccountsAdunitsGet_598098(
    name: "adsensehostAccountsAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsensehostAccountsAdunitsGet_598099,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsGet_598100,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsDelete_598115 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAccountsAdunitsDelete_598117(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsensehostAccountsAdunitsDelete_598116(path: JsonNode;
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
  var valid_598118 = path.getOrDefault("accountId")
  valid_598118 = validateParameter(valid_598118, JString, required = true,
                                 default = nil)
  if valid_598118 != nil:
    section.add "accountId", valid_598118
  var valid_598119 = path.getOrDefault("adClientId")
  valid_598119 = validateParameter(valid_598119, JString, required = true,
                                 default = nil)
  if valid_598119 != nil:
    section.add "adClientId", valid_598119
  var valid_598120 = path.getOrDefault("adUnitId")
  valid_598120 = validateParameter(valid_598120, JString, required = true,
                                 default = nil)
  if valid_598120 != nil:
    section.add "adUnitId", valid_598120
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
  var valid_598121 = query.getOrDefault("fields")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "fields", valid_598121
  var valid_598122 = query.getOrDefault("quotaUser")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "quotaUser", valid_598122
  var valid_598123 = query.getOrDefault("alt")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = newJString("json"))
  if valid_598123 != nil:
    section.add "alt", valid_598123
  var valid_598124 = query.getOrDefault("oauth_token")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "oauth_token", valid_598124
  var valid_598125 = query.getOrDefault("userIp")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "userIp", valid_598125
  var valid_598126 = query.getOrDefault("key")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = nil)
  if valid_598126 != nil:
    section.add "key", valid_598126
  var valid_598127 = query.getOrDefault("prettyPrint")
  valid_598127 = validateParameter(valid_598127, JBool, required = false,
                                 default = newJBool(true))
  if valid_598127 != nil:
    section.add "prettyPrint", valid_598127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598128: Call_AdsensehostAccountsAdunitsDelete_598115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the specified ad unit from the specified publisher AdSense account.
  ## 
  let valid = call_598128.validator(path, query, header, formData, body)
  let scheme = call_598128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598128.url(scheme.get, call_598128.host, call_598128.base,
                         call_598128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598128, url, valid)

proc call*(call_598129: Call_AdsensehostAccountsAdunitsDelete_598115;
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
  var path_598130 = newJObject()
  var query_598131 = newJObject()
  add(query_598131, "fields", newJString(fields))
  add(query_598131, "quotaUser", newJString(quotaUser))
  add(query_598131, "alt", newJString(alt))
  add(query_598131, "oauth_token", newJString(oauthToken))
  add(path_598130, "accountId", newJString(accountId))
  add(query_598131, "userIp", newJString(userIp))
  add(query_598131, "key", newJString(key))
  add(path_598130, "adClientId", newJString(adClientId))
  add(path_598130, "adUnitId", newJString(adUnitId))
  add(query_598131, "prettyPrint", newJBool(prettyPrint))
  result = call_598129.call(path_598130, query_598131, nil, nil, nil)

var adsensehostAccountsAdunitsDelete* = Call_AdsensehostAccountsAdunitsDelete_598115(
    name: "adsensehostAccountsAdunitsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsensehostAccountsAdunitsDelete_598116,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsDelete_598117,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsGetAdCode_598132 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAccountsAdunitsGetAdCode_598134(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsensehostAccountsAdunitsGetAdCode_598133(path: JsonNode;
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
  var valid_598135 = path.getOrDefault("accountId")
  valid_598135 = validateParameter(valid_598135, JString, required = true,
                                 default = nil)
  if valid_598135 != nil:
    section.add "accountId", valid_598135
  var valid_598136 = path.getOrDefault("adClientId")
  valid_598136 = validateParameter(valid_598136, JString, required = true,
                                 default = nil)
  if valid_598136 != nil:
    section.add "adClientId", valid_598136
  var valid_598137 = path.getOrDefault("adUnitId")
  valid_598137 = validateParameter(valid_598137, JString, required = true,
                                 default = nil)
  if valid_598137 != nil:
    section.add "adUnitId", valid_598137
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
  var valid_598138 = query.getOrDefault("fields")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "fields", valid_598138
  var valid_598139 = query.getOrDefault("quotaUser")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "quotaUser", valid_598139
  var valid_598140 = query.getOrDefault("alt")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = newJString("json"))
  if valid_598140 != nil:
    section.add "alt", valid_598140
  var valid_598141 = query.getOrDefault("hostCustomChannelId")
  valid_598141 = validateParameter(valid_598141, JArray, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "hostCustomChannelId", valid_598141
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
  var valid_598144 = query.getOrDefault("key")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "key", valid_598144
  var valid_598145 = query.getOrDefault("prettyPrint")
  valid_598145 = validateParameter(valid_598145, JBool, required = false,
                                 default = newJBool(true))
  if valid_598145 != nil:
    section.add "prettyPrint", valid_598145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598146: Call_AdsensehostAccountsAdunitsGetAdCode_598132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit, attaching the specified host custom channels.
  ## 
  let valid = call_598146.validator(path, query, header, formData, body)
  let scheme = call_598146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598146.url(scheme.get, call_598146.host, call_598146.base,
                         call_598146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598146, url, valid)

proc call*(call_598147: Call_AdsensehostAccountsAdunitsGetAdCode_598132;
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
  var path_598148 = newJObject()
  var query_598149 = newJObject()
  add(query_598149, "fields", newJString(fields))
  add(query_598149, "quotaUser", newJString(quotaUser))
  add(query_598149, "alt", newJString(alt))
  if hostCustomChannelId != nil:
    query_598149.add "hostCustomChannelId", hostCustomChannelId
  add(query_598149, "oauth_token", newJString(oauthToken))
  add(path_598148, "accountId", newJString(accountId))
  add(query_598149, "userIp", newJString(userIp))
  add(query_598149, "key", newJString(key))
  add(path_598148, "adClientId", newJString(adClientId))
  add(path_598148, "adUnitId", newJString(adUnitId))
  add(query_598149, "prettyPrint", newJBool(prettyPrint))
  result = call_598147.call(path_598148, query_598149, nil, nil, nil)

var adsensehostAccountsAdunitsGetAdCode* = Call_AdsensehostAccountsAdunitsGetAdCode_598132(
    name: "adsensehostAccountsAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsensehostAccountsAdunitsGetAdCode_598133,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsGetAdCode_598134,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsReportsGenerate_598150 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAccountsReportsGenerate_598152(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsensehostAccountsReportsGenerate_598151(path: JsonNode;
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
  var valid_598153 = path.getOrDefault("accountId")
  valid_598153 = validateParameter(valid_598153, JString, required = true,
                                 default = nil)
  if valid_598153 != nil:
    section.add "accountId", valid_598153
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
  var valid_598154 = query.getOrDefault("locale")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "locale", valid_598154
  var valid_598155 = query.getOrDefault("fields")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = nil)
  if valid_598155 != nil:
    section.add "fields", valid_598155
  var valid_598156 = query.getOrDefault("quotaUser")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "quotaUser", valid_598156
  var valid_598157 = query.getOrDefault("alt")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = newJString("json"))
  if valid_598157 != nil:
    section.add "alt", valid_598157
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_598158 = query.getOrDefault("endDate")
  valid_598158 = validateParameter(valid_598158, JString, required = true,
                                 default = nil)
  if valid_598158 != nil:
    section.add "endDate", valid_598158
  var valid_598159 = query.getOrDefault("startDate")
  valid_598159 = validateParameter(valid_598159, JString, required = true,
                                 default = nil)
  if valid_598159 != nil:
    section.add "startDate", valid_598159
  var valid_598160 = query.getOrDefault("sort")
  valid_598160 = validateParameter(valid_598160, JArray, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "sort", valid_598160
  var valid_598161 = query.getOrDefault("oauth_token")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "oauth_token", valid_598161
  var valid_598162 = query.getOrDefault("userIp")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "userIp", valid_598162
  var valid_598163 = query.getOrDefault("maxResults")
  valid_598163 = validateParameter(valid_598163, JInt, required = false, default = nil)
  if valid_598163 != nil:
    section.add "maxResults", valid_598163
  var valid_598164 = query.getOrDefault("key")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "key", valid_598164
  var valid_598165 = query.getOrDefault("metric")
  valid_598165 = validateParameter(valid_598165, JArray, required = false,
                                 default = nil)
  if valid_598165 != nil:
    section.add "metric", valid_598165
  var valid_598166 = query.getOrDefault("prettyPrint")
  valid_598166 = validateParameter(valid_598166, JBool, required = false,
                                 default = newJBool(true))
  if valid_598166 != nil:
    section.add "prettyPrint", valid_598166
  var valid_598167 = query.getOrDefault("dimension")
  valid_598167 = validateParameter(valid_598167, JArray, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "dimension", valid_598167
  var valid_598168 = query.getOrDefault("filter")
  valid_598168 = validateParameter(valid_598168, JArray, required = false,
                                 default = nil)
  if valid_598168 != nil:
    section.add "filter", valid_598168
  var valid_598169 = query.getOrDefault("startIndex")
  valid_598169 = validateParameter(valid_598169, JInt, required = false, default = nil)
  if valid_598169 != nil:
    section.add "startIndex", valid_598169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598170: Call_AdsensehostAccountsReportsGenerate_598150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_598170.validator(path, query, header, formData, body)
  let scheme = call_598170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598170.url(scheme.get, call_598170.host, call_598170.base,
                         call_598170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598170, url, valid)

proc call*(call_598171: Call_AdsensehostAccountsReportsGenerate_598150;
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
  var path_598172 = newJObject()
  var query_598173 = newJObject()
  add(query_598173, "locale", newJString(locale))
  add(query_598173, "fields", newJString(fields))
  add(query_598173, "quotaUser", newJString(quotaUser))
  add(query_598173, "alt", newJString(alt))
  add(query_598173, "endDate", newJString(endDate))
  add(query_598173, "startDate", newJString(startDate))
  if sort != nil:
    query_598173.add "sort", sort
  add(query_598173, "oauth_token", newJString(oauthToken))
  add(path_598172, "accountId", newJString(accountId))
  add(query_598173, "userIp", newJString(userIp))
  add(query_598173, "maxResults", newJInt(maxResults))
  add(query_598173, "key", newJString(key))
  if metric != nil:
    query_598173.add "metric", metric
  add(query_598173, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_598173.add "dimension", dimension
  if filter != nil:
    query_598173.add "filter", filter
  add(query_598173, "startIndex", newJInt(startIndex))
  result = call_598171.call(path_598172, query_598173, nil, nil, nil)

var adsensehostAccountsReportsGenerate* = Call_AdsensehostAccountsReportsGenerate_598150(
    name: "adsensehostAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdsensehostAccountsReportsGenerate_598151,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsReportsGenerate_598152,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAdclientsList_598174 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAdclientsList_598176(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsensehostAdclientsList_598175(path: JsonNode; query: JsonNode;
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
  var valid_598177 = query.getOrDefault("fields")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "fields", valid_598177
  var valid_598178 = query.getOrDefault("pageToken")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "pageToken", valid_598178
  var valid_598179 = query.getOrDefault("quotaUser")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "quotaUser", valid_598179
  var valid_598180 = query.getOrDefault("alt")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = newJString("json"))
  if valid_598180 != nil:
    section.add "alt", valid_598180
  var valid_598181 = query.getOrDefault("oauth_token")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "oauth_token", valid_598181
  var valid_598182 = query.getOrDefault("userIp")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = nil)
  if valid_598182 != nil:
    section.add "userIp", valid_598182
  var valid_598183 = query.getOrDefault("maxResults")
  valid_598183 = validateParameter(valid_598183, JInt, required = false, default = nil)
  if valid_598183 != nil:
    section.add "maxResults", valid_598183
  var valid_598184 = query.getOrDefault("key")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "key", valid_598184
  var valid_598185 = query.getOrDefault("prettyPrint")
  valid_598185 = validateParameter(valid_598185, JBool, required = false,
                                 default = newJBool(true))
  if valid_598185 != nil:
    section.add "prettyPrint", valid_598185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598186: Call_AdsensehostAdclientsList_598174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all host ad clients in this AdSense account.
  ## 
  let valid = call_598186.validator(path, query, header, formData, body)
  let scheme = call_598186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598186.url(scheme.get, call_598186.host, call_598186.base,
                         call_598186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598186, url, valid)

proc call*(call_598187: Call_AdsensehostAdclientsList_598174; fields: string = "";
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
  var query_598188 = newJObject()
  add(query_598188, "fields", newJString(fields))
  add(query_598188, "pageToken", newJString(pageToken))
  add(query_598188, "quotaUser", newJString(quotaUser))
  add(query_598188, "alt", newJString(alt))
  add(query_598188, "oauth_token", newJString(oauthToken))
  add(query_598188, "userIp", newJString(userIp))
  add(query_598188, "maxResults", newJInt(maxResults))
  add(query_598188, "key", newJString(key))
  add(query_598188, "prettyPrint", newJBool(prettyPrint))
  result = call_598187.call(nil, query_598188, nil, nil, nil)

var adsensehostAdclientsList* = Call_AdsensehostAdclientsList_598174(
    name: "adsensehostAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdsensehostAdclientsList_598175,
    base: "/adsensehost/v4.1", url: url_AdsensehostAdclientsList_598176,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAdclientsGet_598189 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAdclientsGet_598191(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAdclientsGet_598190(path: JsonNode; query: JsonNode;
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
  var valid_598192 = path.getOrDefault("adClientId")
  valid_598192 = validateParameter(valid_598192, JString, required = true,
                                 default = nil)
  if valid_598192 != nil:
    section.add "adClientId", valid_598192
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
  var valid_598193 = query.getOrDefault("fields")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = nil)
  if valid_598193 != nil:
    section.add "fields", valid_598193
  var valid_598194 = query.getOrDefault("quotaUser")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = nil)
  if valid_598194 != nil:
    section.add "quotaUser", valid_598194
  var valid_598195 = query.getOrDefault("alt")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = newJString("json"))
  if valid_598195 != nil:
    section.add "alt", valid_598195
  var valid_598196 = query.getOrDefault("oauth_token")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "oauth_token", valid_598196
  var valid_598197 = query.getOrDefault("userIp")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "userIp", valid_598197
  var valid_598198 = query.getOrDefault("key")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = nil)
  if valid_598198 != nil:
    section.add "key", valid_598198
  var valid_598199 = query.getOrDefault("prettyPrint")
  valid_598199 = validateParameter(valid_598199, JBool, required = false,
                                 default = newJBool(true))
  if valid_598199 != nil:
    section.add "prettyPrint", valid_598199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598200: Call_AdsensehostAdclientsGet_598189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about one of the ad clients in the Host AdSense account.
  ## 
  let valid = call_598200.validator(path, query, header, formData, body)
  let scheme = call_598200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598200.url(scheme.get, call_598200.host, call_598200.base,
                         call_598200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598200, url, valid)

proc call*(call_598201: Call_AdsensehostAdclientsGet_598189; adClientId: string;
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
  var path_598202 = newJObject()
  var query_598203 = newJObject()
  add(query_598203, "fields", newJString(fields))
  add(query_598203, "quotaUser", newJString(quotaUser))
  add(query_598203, "alt", newJString(alt))
  add(query_598203, "oauth_token", newJString(oauthToken))
  add(query_598203, "userIp", newJString(userIp))
  add(query_598203, "key", newJString(key))
  add(path_598202, "adClientId", newJString(adClientId))
  add(query_598203, "prettyPrint", newJBool(prettyPrint))
  result = call_598201.call(path_598202, query_598203, nil, nil, nil)

var adsensehostAdclientsGet* = Call_AdsensehostAdclientsGet_598189(
    name: "adsensehostAdclientsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}",
    validator: validate_AdsensehostAdclientsGet_598190, base: "/adsensehost/v4.1",
    url: url_AdsensehostAdclientsGet_598191, schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsUpdate_598221 = ref object of OpenApiRestCall_597424
proc url_AdsensehostCustomchannelsUpdate_598223(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsUpdate_598222(path: JsonNode;
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
  var valid_598224 = path.getOrDefault("adClientId")
  valid_598224 = validateParameter(valid_598224, JString, required = true,
                                 default = nil)
  if valid_598224 != nil:
    section.add "adClientId", valid_598224
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
  var valid_598225 = query.getOrDefault("fields")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "fields", valid_598225
  var valid_598226 = query.getOrDefault("quotaUser")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "quotaUser", valid_598226
  var valid_598227 = query.getOrDefault("alt")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = newJString("json"))
  if valid_598227 != nil:
    section.add "alt", valid_598227
  var valid_598228 = query.getOrDefault("oauth_token")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = nil)
  if valid_598228 != nil:
    section.add "oauth_token", valid_598228
  var valid_598229 = query.getOrDefault("userIp")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "userIp", valid_598229
  var valid_598230 = query.getOrDefault("key")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "key", valid_598230
  var valid_598231 = query.getOrDefault("prettyPrint")
  valid_598231 = validateParameter(valid_598231, JBool, required = false,
                                 default = newJBool(true))
  if valid_598231 != nil:
    section.add "prettyPrint", valid_598231
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

proc call*(call_598233: Call_AdsensehostCustomchannelsUpdate_598221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a custom channel in the host AdSense account.
  ## 
  let valid = call_598233.validator(path, query, header, formData, body)
  let scheme = call_598233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598233.url(scheme.get, call_598233.host, call_598233.base,
                         call_598233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598233, url, valid)

proc call*(call_598234: Call_AdsensehostCustomchannelsUpdate_598221;
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
  var path_598235 = newJObject()
  var query_598236 = newJObject()
  var body_598237 = newJObject()
  add(query_598236, "fields", newJString(fields))
  add(query_598236, "quotaUser", newJString(quotaUser))
  add(query_598236, "alt", newJString(alt))
  add(query_598236, "oauth_token", newJString(oauthToken))
  add(query_598236, "userIp", newJString(userIp))
  add(query_598236, "key", newJString(key))
  add(path_598235, "adClientId", newJString(adClientId))
  if body != nil:
    body_598237 = body
  add(query_598236, "prettyPrint", newJBool(prettyPrint))
  result = call_598234.call(path_598235, query_598236, nil, nil, body_598237)

var adsensehostCustomchannelsUpdate* = Call_AdsensehostCustomchannelsUpdate_598221(
    name: "adsensehostCustomchannelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsUpdate_598222,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsUpdate_598223,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsInsert_598238 = ref object of OpenApiRestCall_597424
proc url_AdsensehostCustomchannelsInsert_598240(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsInsert_598239(path: JsonNode;
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
  var valid_598241 = path.getOrDefault("adClientId")
  valid_598241 = validateParameter(valid_598241, JString, required = true,
                                 default = nil)
  if valid_598241 != nil:
    section.add "adClientId", valid_598241
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
  var valid_598242 = query.getOrDefault("fields")
  valid_598242 = validateParameter(valid_598242, JString, required = false,
                                 default = nil)
  if valid_598242 != nil:
    section.add "fields", valid_598242
  var valid_598243 = query.getOrDefault("quotaUser")
  valid_598243 = validateParameter(valid_598243, JString, required = false,
                                 default = nil)
  if valid_598243 != nil:
    section.add "quotaUser", valid_598243
  var valid_598244 = query.getOrDefault("alt")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = newJString("json"))
  if valid_598244 != nil:
    section.add "alt", valid_598244
  var valid_598245 = query.getOrDefault("oauth_token")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "oauth_token", valid_598245
  var valid_598246 = query.getOrDefault("userIp")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "userIp", valid_598246
  var valid_598247 = query.getOrDefault("key")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "key", valid_598247
  var valid_598248 = query.getOrDefault("prettyPrint")
  valid_598248 = validateParameter(valid_598248, JBool, required = false,
                                 default = newJBool(true))
  if valid_598248 != nil:
    section.add "prettyPrint", valid_598248
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

proc call*(call_598250: Call_AdsensehostCustomchannelsInsert_598238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a new custom channel to the host AdSense account.
  ## 
  let valid = call_598250.validator(path, query, header, formData, body)
  let scheme = call_598250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598250.url(scheme.get, call_598250.host, call_598250.base,
                         call_598250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598250, url, valid)

proc call*(call_598251: Call_AdsensehostCustomchannelsInsert_598238;
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
  var path_598252 = newJObject()
  var query_598253 = newJObject()
  var body_598254 = newJObject()
  add(query_598253, "fields", newJString(fields))
  add(query_598253, "quotaUser", newJString(quotaUser))
  add(query_598253, "alt", newJString(alt))
  add(query_598253, "oauth_token", newJString(oauthToken))
  add(query_598253, "userIp", newJString(userIp))
  add(query_598253, "key", newJString(key))
  add(path_598252, "adClientId", newJString(adClientId))
  if body != nil:
    body_598254 = body
  add(query_598253, "prettyPrint", newJBool(prettyPrint))
  result = call_598251.call(path_598252, query_598253, nil, nil, body_598254)

var adsensehostCustomchannelsInsert* = Call_AdsensehostCustomchannelsInsert_598238(
    name: "adsensehostCustomchannelsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsInsert_598239,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsInsert_598240,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsList_598204 = ref object of OpenApiRestCall_597424
proc url_AdsensehostCustomchannelsList_598206(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsList_598205(path: JsonNode; query: JsonNode;
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
  var valid_598207 = path.getOrDefault("adClientId")
  valid_598207 = validateParameter(valid_598207, JString, required = true,
                                 default = nil)
  if valid_598207 != nil:
    section.add "adClientId", valid_598207
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
  var valid_598208 = query.getOrDefault("fields")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "fields", valid_598208
  var valid_598209 = query.getOrDefault("pageToken")
  valid_598209 = validateParameter(valid_598209, JString, required = false,
                                 default = nil)
  if valid_598209 != nil:
    section.add "pageToken", valid_598209
  var valid_598210 = query.getOrDefault("quotaUser")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "quotaUser", valid_598210
  var valid_598211 = query.getOrDefault("alt")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = newJString("json"))
  if valid_598211 != nil:
    section.add "alt", valid_598211
  var valid_598212 = query.getOrDefault("oauth_token")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = nil)
  if valid_598212 != nil:
    section.add "oauth_token", valid_598212
  var valid_598213 = query.getOrDefault("userIp")
  valid_598213 = validateParameter(valid_598213, JString, required = false,
                                 default = nil)
  if valid_598213 != nil:
    section.add "userIp", valid_598213
  var valid_598214 = query.getOrDefault("maxResults")
  valid_598214 = validateParameter(valid_598214, JInt, required = false, default = nil)
  if valid_598214 != nil:
    section.add "maxResults", valid_598214
  var valid_598215 = query.getOrDefault("key")
  valid_598215 = validateParameter(valid_598215, JString, required = false,
                                 default = nil)
  if valid_598215 != nil:
    section.add "key", valid_598215
  var valid_598216 = query.getOrDefault("prettyPrint")
  valid_598216 = validateParameter(valid_598216, JBool, required = false,
                                 default = newJBool(true))
  if valid_598216 != nil:
    section.add "prettyPrint", valid_598216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598217: Call_AdsensehostCustomchannelsList_598204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all host custom channels in this AdSense account.
  ## 
  let valid = call_598217.validator(path, query, header, formData, body)
  let scheme = call_598217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598217.url(scheme.get, call_598217.host, call_598217.base,
                         call_598217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598217, url, valid)

proc call*(call_598218: Call_AdsensehostCustomchannelsList_598204;
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
  var path_598219 = newJObject()
  var query_598220 = newJObject()
  add(query_598220, "fields", newJString(fields))
  add(query_598220, "pageToken", newJString(pageToken))
  add(query_598220, "quotaUser", newJString(quotaUser))
  add(query_598220, "alt", newJString(alt))
  add(query_598220, "oauth_token", newJString(oauthToken))
  add(query_598220, "userIp", newJString(userIp))
  add(query_598220, "maxResults", newJInt(maxResults))
  add(query_598220, "key", newJString(key))
  add(path_598219, "adClientId", newJString(adClientId))
  add(query_598220, "prettyPrint", newJBool(prettyPrint))
  result = call_598218.call(path_598219, query_598220, nil, nil, nil)

var adsensehostCustomchannelsList* = Call_AdsensehostCustomchannelsList_598204(
    name: "adsensehostCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsList_598205,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsList_598206,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsPatch_598255 = ref object of OpenApiRestCall_597424
proc url_AdsensehostCustomchannelsPatch_598257(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsPatch_598256(path: JsonNode;
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
  var valid_598258 = path.getOrDefault("adClientId")
  valid_598258 = validateParameter(valid_598258, JString, required = true,
                                 default = nil)
  if valid_598258 != nil:
    section.add "adClientId", valid_598258
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
  var valid_598259 = query.getOrDefault("fields")
  valid_598259 = validateParameter(valid_598259, JString, required = false,
                                 default = nil)
  if valid_598259 != nil:
    section.add "fields", valid_598259
  var valid_598260 = query.getOrDefault("quotaUser")
  valid_598260 = validateParameter(valid_598260, JString, required = false,
                                 default = nil)
  if valid_598260 != nil:
    section.add "quotaUser", valid_598260
  var valid_598261 = query.getOrDefault("alt")
  valid_598261 = validateParameter(valid_598261, JString, required = false,
                                 default = newJString("json"))
  if valid_598261 != nil:
    section.add "alt", valid_598261
  assert query != nil,
        "query argument is necessary due to required `customChannelId` field"
  var valid_598262 = query.getOrDefault("customChannelId")
  valid_598262 = validateParameter(valid_598262, JString, required = true,
                                 default = nil)
  if valid_598262 != nil:
    section.add "customChannelId", valid_598262
  var valid_598263 = query.getOrDefault("oauth_token")
  valid_598263 = validateParameter(valid_598263, JString, required = false,
                                 default = nil)
  if valid_598263 != nil:
    section.add "oauth_token", valid_598263
  var valid_598264 = query.getOrDefault("userIp")
  valid_598264 = validateParameter(valid_598264, JString, required = false,
                                 default = nil)
  if valid_598264 != nil:
    section.add "userIp", valid_598264
  var valid_598265 = query.getOrDefault("key")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = nil)
  if valid_598265 != nil:
    section.add "key", valid_598265
  var valid_598266 = query.getOrDefault("prettyPrint")
  valid_598266 = validateParameter(valid_598266, JBool, required = false,
                                 default = newJBool(true))
  if valid_598266 != nil:
    section.add "prettyPrint", valid_598266
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

proc call*(call_598268: Call_AdsensehostCustomchannelsPatch_598255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a custom channel in the host AdSense account. This method supports patch semantics.
  ## 
  let valid = call_598268.validator(path, query, header, formData, body)
  let scheme = call_598268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598268.url(scheme.get, call_598268.host, call_598268.base,
                         call_598268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598268, url, valid)

proc call*(call_598269: Call_AdsensehostCustomchannelsPatch_598255;
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
  var path_598270 = newJObject()
  var query_598271 = newJObject()
  var body_598272 = newJObject()
  add(query_598271, "fields", newJString(fields))
  add(query_598271, "quotaUser", newJString(quotaUser))
  add(query_598271, "alt", newJString(alt))
  add(query_598271, "customChannelId", newJString(customChannelId))
  add(query_598271, "oauth_token", newJString(oauthToken))
  add(query_598271, "userIp", newJString(userIp))
  add(query_598271, "key", newJString(key))
  add(path_598270, "adClientId", newJString(adClientId))
  if body != nil:
    body_598272 = body
  add(query_598271, "prettyPrint", newJBool(prettyPrint))
  result = call_598269.call(path_598270, query_598271, nil, nil, body_598272)

var adsensehostCustomchannelsPatch* = Call_AdsensehostCustomchannelsPatch_598255(
    name: "adsensehostCustomchannelsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsPatch_598256,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsPatch_598257,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsGet_598273 = ref object of OpenApiRestCall_597424
proc url_AdsensehostCustomchannelsGet_598275(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsGet_598274(path: JsonNode; query: JsonNode;
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
  var valid_598276 = path.getOrDefault("customChannelId")
  valid_598276 = validateParameter(valid_598276, JString, required = true,
                                 default = nil)
  if valid_598276 != nil:
    section.add "customChannelId", valid_598276
  var valid_598277 = path.getOrDefault("adClientId")
  valid_598277 = validateParameter(valid_598277, JString, required = true,
                                 default = nil)
  if valid_598277 != nil:
    section.add "adClientId", valid_598277
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
  var valid_598278 = query.getOrDefault("fields")
  valid_598278 = validateParameter(valid_598278, JString, required = false,
                                 default = nil)
  if valid_598278 != nil:
    section.add "fields", valid_598278
  var valid_598279 = query.getOrDefault("quotaUser")
  valid_598279 = validateParameter(valid_598279, JString, required = false,
                                 default = nil)
  if valid_598279 != nil:
    section.add "quotaUser", valid_598279
  var valid_598280 = query.getOrDefault("alt")
  valid_598280 = validateParameter(valid_598280, JString, required = false,
                                 default = newJString("json"))
  if valid_598280 != nil:
    section.add "alt", valid_598280
  var valid_598281 = query.getOrDefault("oauth_token")
  valid_598281 = validateParameter(valid_598281, JString, required = false,
                                 default = nil)
  if valid_598281 != nil:
    section.add "oauth_token", valid_598281
  var valid_598282 = query.getOrDefault("userIp")
  valid_598282 = validateParameter(valid_598282, JString, required = false,
                                 default = nil)
  if valid_598282 != nil:
    section.add "userIp", valid_598282
  var valid_598283 = query.getOrDefault("key")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = nil)
  if valid_598283 != nil:
    section.add "key", valid_598283
  var valid_598284 = query.getOrDefault("prettyPrint")
  valid_598284 = validateParameter(valid_598284, JBool, required = false,
                                 default = newJBool(true))
  if valid_598284 != nil:
    section.add "prettyPrint", valid_598284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598285: Call_AdsensehostCustomchannelsGet_598273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific custom channel from the host AdSense account.
  ## 
  let valid = call_598285.validator(path, query, header, formData, body)
  let scheme = call_598285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598285.url(scheme.get, call_598285.host, call_598285.base,
                         call_598285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598285, url, valid)

proc call*(call_598286: Call_AdsensehostCustomchannelsGet_598273;
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
  var path_598287 = newJObject()
  var query_598288 = newJObject()
  add(query_598288, "fields", newJString(fields))
  add(query_598288, "quotaUser", newJString(quotaUser))
  add(query_598288, "alt", newJString(alt))
  add(query_598288, "oauth_token", newJString(oauthToken))
  add(path_598287, "customChannelId", newJString(customChannelId))
  add(query_598288, "userIp", newJString(userIp))
  add(query_598288, "key", newJString(key))
  add(path_598287, "adClientId", newJString(adClientId))
  add(query_598288, "prettyPrint", newJBool(prettyPrint))
  result = call_598286.call(path_598287, query_598288, nil, nil, nil)

var adsensehostCustomchannelsGet* = Call_AdsensehostCustomchannelsGet_598273(
    name: "adsensehostCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsensehostCustomchannelsGet_598274,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsGet_598275,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsDelete_598289 = ref object of OpenApiRestCall_597424
proc url_AdsensehostCustomchannelsDelete_598291(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsDelete_598290(path: JsonNode;
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
  var valid_598292 = path.getOrDefault("customChannelId")
  valid_598292 = validateParameter(valid_598292, JString, required = true,
                                 default = nil)
  if valid_598292 != nil:
    section.add "customChannelId", valid_598292
  var valid_598293 = path.getOrDefault("adClientId")
  valid_598293 = validateParameter(valid_598293, JString, required = true,
                                 default = nil)
  if valid_598293 != nil:
    section.add "adClientId", valid_598293
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
  var valid_598294 = query.getOrDefault("fields")
  valid_598294 = validateParameter(valid_598294, JString, required = false,
                                 default = nil)
  if valid_598294 != nil:
    section.add "fields", valid_598294
  var valid_598295 = query.getOrDefault("quotaUser")
  valid_598295 = validateParameter(valid_598295, JString, required = false,
                                 default = nil)
  if valid_598295 != nil:
    section.add "quotaUser", valid_598295
  var valid_598296 = query.getOrDefault("alt")
  valid_598296 = validateParameter(valid_598296, JString, required = false,
                                 default = newJString("json"))
  if valid_598296 != nil:
    section.add "alt", valid_598296
  var valid_598297 = query.getOrDefault("oauth_token")
  valid_598297 = validateParameter(valid_598297, JString, required = false,
                                 default = nil)
  if valid_598297 != nil:
    section.add "oauth_token", valid_598297
  var valid_598298 = query.getOrDefault("userIp")
  valid_598298 = validateParameter(valid_598298, JString, required = false,
                                 default = nil)
  if valid_598298 != nil:
    section.add "userIp", valid_598298
  var valid_598299 = query.getOrDefault("key")
  valid_598299 = validateParameter(valid_598299, JString, required = false,
                                 default = nil)
  if valid_598299 != nil:
    section.add "key", valid_598299
  var valid_598300 = query.getOrDefault("prettyPrint")
  valid_598300 = validateParameter(valid_598300, JBool, required = false,
                                 default = newJBool(true))
  if valid_598300 != nil:
    section.add "prettyPrint", valid_598300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598301: Call_AdsensehostCustomchannelsDelete_598289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a specific custom channel from the host AdSense account.
  ## 
  let valid = call_598301.validator(path, query, header, formData, body)
  let scheme = call_598301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598301.url(scheme.get, call_598301.host, call_598301.base,
                         call_598301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598301, url, valid)

proc call*(call_598302: Call_AdsensehostCustomchannelsDelete_598289;
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
  var path_598303 = newJObject()
  var query_598304 = newJObject()
  add(query_598304, "fields", newJString(fields))
  add(query_598304, "quotaUser", newJString(quotaUser))
  add(query_598304, "alt", newJString(alt))
  add(query_598304, "oauth_token", newJString(oauthToken))
  add(path_598303, "customChannelId", newJString(customChannelId))
  add(query_598304, "userIp", newJString(userIp))
  add(query_598304, "key", newJString(key))
  add(path_598303, "adClientId", newJString(adClientId))
  add(query_598304, "prettyPrint", newJBool(prettyPrint))
  result = call_598302.call(path_598303, query_598304, nil, nil, nil)

var adsensehostCustomchannelsDelete* = Call_AdsensehostCustomchannelsDelete_598289(
    name: "adsensehostCustomchannelsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsensehostCustomchannelsDelete_598290,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsDelete_598291,
    schemes: {Scheme.Https})
type
  Call_AdsensehostUrlchannelsInsert_598322 = ref object of OpenApiRestCall_597424
proc url_AdsensehostUrlchannelsInsert_598324(protocol: Scheme; host: string;
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

proc validate_AdsensehostUrlchannelsInsert_598323(path: JsonNode; query: JsonNode;
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
  var valid_598325 = path.getOrDefault("adClientId")
  valid_598325 = validateParameter(valid_598325, JString, required = true,
                                 default = nil)
  if valid_598325 != nil:
    section.add "adClientId", valid_598325
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
  var valid_598326 = query.getOrDefault("fields")
  valid_598326 = validateParameter(valid_598326, JString, required = false,
                                 default = nil)
  if valid_598326 != nil:
    section.add "fields", valid_598326
  var valid_598327 = query.getOrDefault("quotaUser")
  valid_598327 = validateParameter(valid_598327, JString, required = false,
                                 default = nil)
  if valid_598327 != nil:
    section.add "quotaUser", valid_598327
  var valid_598328 = query.getOrDefault("alt")
  valid_598328 = validateParameter(valid_598328, JString, required = false,
                                 default = newJString("json"))
  if valid_598328 != nil:
    section.add "alt", valid_598328
  var valid_598329 = query.getOrDefault("oauth_token")
  valid_598329 = validateParameter(valid_598329, JString, required = false,
                                 default = nil)
  if valid_598329 != nil:
    section.add "oauth_token", valid_598329
  var valid_598330 = query.getOrDefault("userIp")
  valid_598330 = validateParameter(valid_598330, JString, required = false,
                                 default = nil)
  if valid_598330 != nil:
    section.add "userIp", valid_598330
  var valid_598331 = query.getOrDefault("key")
  valid_598331 = validateParameter(valid_598331, JString, required = false,
                                 default = nil)
  if valid_598331 != nil:
    section.add "key", valid_598331
  var valid_598332 = query.getOrDefault("prettyPrint")
  valid_598332 = validateParameter(valid_598332, JBool, required = false,
                                 default = newJBool(true))
  if valid_598332 != nil:
    section.add "prettyPrint", valid_598332
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

proc call*(call_598334: Call_AdsensehostUrlchannelsInsert_598322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new URL channel to the host AdSense account.
  ## 
  let valid = call_598334.validator(path, query, header, formData, body)
  let scheme = call_598334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598334.url(scheme.get, call_598334.host, call_598334.base,
                         call_598334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598334, url, valid)

proc call*(call_598335: Call_AdsensehostUrlchannelsInsert_598322;
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
  var path_598336 = newJObject()
  var query_598337 = newJObject()
  var body_598338 = newJObject()
  add(query_598337, "fields", newJString(fields))
  add(query_598337, "quotaUser", newJString(quotaUser))
  add(query_598337, "alt", newJString(alt))
  add(query_598337, "oauth_token", newJString(oauthToken))
  add(query_598337, "userIp", newJString(userIp))
  add(query_598337, "key", newJString(key))
  add(path_598336, "adClientId", newJString(adClientId))
  if body != nil:
    body_598338 = body
  add(query_598337, "prettyPrint", newJBool(prettyPrint))
  result = call_598335.call(path_598336, query_598337, nil, nil, body_598338)

var adsensehostUrlchannelsInsert* = Call_AdsensehostUrlchannelsInsert_598322(
    name: "adsensehostUrlchannelsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsensehostUrlchannelsInsert_598323,
    base: "/adsensehost/v4.1", url: url_AdsensehostUrlchannelsInsert_598324,
    schemes: {Scheme.Https})
type
  Call_AdsensehostUrlchannelsList_598305 = ref object of OpenApiRestCall_597424
proc url_AdsensehostUrlchannelsList_598307(protocol: Scheme; host: string;
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

proc validate_AdsensehostUrlchannelsList_598306(path: JsonNode; query: JsonNode;
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
  var valid_598308 = path.getOrDefault("adClientId")
  valid_598308 = validateParameter(valid_598308, JString, required = true,
                                 default = nil)
  if valid_598308 != nil:
    section.add "adClientId", valid_598308
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
  var valid_598309 = query.getOrDefault("fields")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = nil)
  if valid_598309 != nil:
    section.add "fields", valid_598309
  var valid_598310 = query.getOrDefault("pageToken")
  valid_598310 = validateParameter(valid_598310, JString, required = false,
                                 default = nil)
  if valid_598310 != nil:
    section.add "pageToken", valid_598310
  var valid_598311 = query.getOrDefault("quotaUser")
  valid_598311 = validateParameter(valid_598311, JString, required = false,
                                 default = nil)
  if valid_598311 != nil:
    section.add "quotaUser", valid_598311
  var valid_598312 = query.getOrDefault("alt")
  valid_598312 = validateParameter(valid_598312, JString, required = false,
                                 default = newJString("json"))
  if valid_598312 != nil:
    section.add "alt", valid_598312
  var valid_598313 = query.getOrDefault("oauth_token")
  valid_598313 = validateParameter(valid_598313, JString, required = false,
                                 default = nil)
  if valid_598313 != nil:
    section.add "oauth_token", valid_598313
  var valid_598314 = query.getOrDefault("userIp")
  valid_598314 = validateParameter(valid_598314, JString, required = false,
                                 default = nil)
  if valid_598314 != nil:
    section.add "userIp", valid_598314
  var valid_598315 = query.getOrDefault("maxResults")
  valid_598315 = validateParameter(valid_598315, JInt, required = false, default = nil)
  if valid_598315 != nil:
    section.add "maxResults", valid_598315
  var valid_598316 = query.getOrDefault("key")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "key", valid_598316
  var valid_598317 = query.getOrDefault("prettyPrint")
  valid_598317 = validateParameter(valid_598317, JBool, required = false,
                                 default = newJBool(true))
  if valid_598317 != nil:
    section.add "prettyPrint", valid_598317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598318: Call_AdsensehostUrlchannelsList_598305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all host URL channels in the host AdSense account.
  ## 
  let valid = call_598318.validator(path, query, header, formData, body)
  let scheme = call_598318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598318.url(scheme.get, call_598318.host, call_598318.base,
                         call_598318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598318, url, valid)

proc call*(call_598319: Call_AdsensehostUrlchannelsList_598305; adClientId: string;
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
  var path_598320 = newJObject()
  var query_598321 = newJObject()
  add(query_598321, "fields", newJString(fields))
  add(query_598321, "pageToken", newJString(pageToken))
  add(query_598321, "quotaUser", newJString(quotaUser))
  add(query_598321, "alt", newJString(alt))
  add(query_598321, "oauth_token", newJString(oauthToken))
  add(query_598321, "userIp", newJString(userIp))
  add(query_598321, "maxResults", newJInt(maxResults))
  add(query_598321, "key", newJString(key))
  add(path_598320, "adClientId", newJString(adClientId))
  add(query_598321, "prettyPrint", newJBool(prettyPrint))
  result = call_598319.call(path_598320, query_598321, nil, nil, nil)

var adsensehostUrlchannelsList* = Call_AdsensehostUrlchannelsList_598305(
    name: "adsensehostUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsensehostUrlchannelsList_598306,
    base: "/adsensehost/v4.1", url: url_AdsensehostUrlchannelsList_598307,
    schemes: {Scheme.Https})
type
  Call_AdsensehostUrlchannelsDelete_598339 = ref object of OpenApiRestCall_597424
proc url_AdsensehostUrlchannelsDelete_598341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsensehostUrlchannelsDelete_598340(path: JsonNode; query: JsonNode;
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
  var valid_598342 = path.getOrDefault("urlChannelId")
  valid_598342 = validateParameter(valid_598342, JString, required = true,
                                 default = nil)
  if valid_598342 != nil:
    section.add "urlChannelId", valid_598342
  var valid_598343 = path.getOrDefault("adClientId")
  valid_598343 = validateParameter(valid_598343, JString, required = true,
                                 default = nil)
  if valid_598343 != nil:
    section.add "adClientId", valid_598343
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
  var valid_598344 = query.getOrDefault("fields")
  valid_598344 = validateParameter(valid_598344, JString, required = false,
                                 default = nil)
  if valid_598344 != nil:
    section.add "fields", valid_598344
  var valid_598345 = query.getOrDefault("quotaUser")
  valid_598345 = validateParameter(valid_598345, JString, required = false,
                                 default = nil)
  if valid_598345 != nil:
    section.add "quotaUser", valid_598345
  var valid_598346 = query.getOrDefault("alt")
  valid_598346 = validateParameter(valid_598346, JString, required = false,
                                 default = newJString("json"))
  if valid_598346 != nil:
    section.add "alt", valid_598346
  var valid_598347 = query.getOrDefault("oauth_token")
  valid_598347 = validateParameter(valid_598347, JString, required = false,
                                 default = nil)
  if valid_598347 != nil:
    section.add "oauth_token", valid_598347
  var valid_598348 = query.getOrDefault("userIp")
  valid_598348 = validateParameter(valid_598348, JString, required = false,
                                 default = nil)
  if valid_598348 != nil:
    section.add "userIp", valid_598348
  var valid_598349 = query.getOrDefault("key")
  valid_598349 = validateParameter(valid_598349, JString, required = false,
                                 default = nil)
  if valid_598349 != nil:
    section.add "key", valid_598349
  var valid_598350 = query.getOrDefault("prettyPrint")
  valid_598350 = validateParameter(valid_598350, JBool, required = false,
                                 default = newJBool(true))
  if valid_598350 != nil:
    section.add "prettyPrint", valid_598350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598351: Call_AdsensehostUrlchannelsDelete_598339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a URL channel from the host AdSense account.
  ## 
  let valid = call_598351.validator(path, query, header, formData, body)
  let scheme = call_598351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598351.url(scheme.get, call_598351.host, call_598351.base,
                         call_598351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598351, url, valid)

proc call*(call_598352: Call_AdsensehostUrlchannelsDelete_598339;
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
  var path_598353 = newJObject()
  var query_598354 = newJObject()
  add(query_598354, "fields", newJString(fields))
  add(query_598354, "quotaUser", newJString(quotaUser))
  add(query_598354, "alt", newJString(alt))
  add(path_598353, "urlChannelId", newJString(urlChannelId))
  add(query_598354, "oauth_token", newJString(oauthToken))
  add(query_598354, "userIp", newJString(userIp))
  add(query_598354, "key", newJString(key))
  add(path_598353, "adClientId", newJString(adClientId))
  add(query_598354, "prettyPrint", newJBool(prettyPrint))
  result = call_598352.call(path_598353, query_598354, nil, nil, nil)

var adsensehostUrlchannelsDelete* = Call_AdsensehostUrlchannelsDelete_598339(
    name: "adsensehostUrlchannelsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/urlchannels/{urlChannelId}",
    validator: validate_AdsensehostUrlchannelsDelete_598340,
    base: "/adsensehost/v4.1", url: url_AdsensehostUrlchannelsDelete_598341,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAssociationsessionsStart_598355 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAssociationsessionsStart_598357(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsensehostAssociationsessionsStart_598356(path: JsonNode;
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
  var valid_598358 = query.getOrDefault("fields")
  valid_598358 = validateParameter(valid_598358, JString, required = false,
                                 default = nil)
  if valid_598358 != nil:
    section.add "fields", valid_598358
  var valid_598359 = query.getOrDefault("quotaUser")
  valid_598359 = validateParameter(valid_598359, JString, required = false,
                                 default = nil)
  if valid_598359 != nil:
    section.add "quotaUser", valid_598359
  var valid_598360 = query.getOrDefault("websiteLocale")
  valid_598360 = validateParameter(valid_598360, JString, required = false,
                                 default = nil)
  if valid_598360 != nil:
    section.add "websiteLocale", valid_598360
  var valid_598361 = query.getOrDefault("alt")
  valid_598361 = validateParameter(valid_598361, JString, required = false,
                                 default = newJString("json"))
  if valid_598361 != nil:
    section.add "alt", valid_598361
  var valid_598362 = query.getOrDefault("userLocale")
  valid_598362 = validateParameter(valid_598362, JString, required = false,
                                 default = nil)
  if valid_598362 != nil:
    section.add "userLocale", valid_598362
  var valid_598363 = query.getOrDefault("oauth_token")
  valid_598363 = validateParameter(valid_598363, JString, required = false,
                                 default = nil)
  if valid_598363 != nil:
    section.add "oauth_token", valid_598363
  var valid_598364 = query.getOrDefault("userIp")
  valid_598364 = validateParameter(valid_598364, JString, required = false,
                                 default = nil)
  if valid_598364 != nil:
    section.add "userIp", valid_598364
  var valid_598365 = query.getOrDefault("key")
  valid_598365 = validateParameter(valid_598365, JString, required = false,
                                 default = nil)
  if valid_598365 != nil:
    section.add "key", valid_598365
  assert query != nil,
        "query argument is necessary due to required `websiteUrl` field"
  var valid_598366 = query.getOrDefault("websiteUrl")
  valid_598366 = validateParameter(valid_598366, JString, required = true,
                                 default = nil)
  if valid_598366 != nil:
    section.add "websiteUrl", valid_598366
  var valid_598367 = query.getOrDefault("productCode")
  valid_598367 = validateParameter(valid_598367, JArray, required = true, default = nil)
  if valid_598367 != nil:
    section.add "productCode", valid_598367
  var valid_598368 = query.getOrDefault("prettyPrint")
  valid_598368 = validateParameter(valid_598368, JBool, required = false,
                                 default = newJBool(true))
  if valid_598368 != nil:
    section.add "prettyPrint", valid_598368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598369: Call_AdsensehostAssociationsessionsStart_598355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an association session for initiating an association with an AdSense user.
  ## 
  let valid = call_598369.validator(path, query, header, formData, body)
  let scheme = call_598369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598369.url(scheme.get, call_598369.host, call_598369.base,
                         call_598369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598369, url, valid)

proc call*(call_598370: Call_AdsensehostAssociationsessionsStart_598355;
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
  var query_598371 = newJObject()
  add(query_598371, "fields", newJString(fields))
  add(query_598371, "quotaUser", newJString(quotaUser))
  add(query_598371, "websiteLocale", newJString(websiteLocale))
  add(query_598371, "alt", newJString(alt))
  add(query_598371, "userLocale", newJString(userLocale))
  add(query_598371, "oauth_token", newJString(oauthToken))
  add(query_598371, "userIp", newJString(userIp))
  add(query_598371, "key", newJString(key))
  add(query_598371, "websiteUrl", newJString(websiteUrl))
  if productCode != nil:
    query_598371.add "productCode", productCode
  add(query_598371, "prettyPrint", newJBool(prettyPrint))
  result = call_598370.call(nil, query_598371, nil, nil, nil)

var adsensehostAssociationsessionsStart* = Call_AdsensehostAssociationsessionsStart_598355(
    name: "adsensehostAssociationsessionsStart", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/associationsessions/start",
    validator: validate_AdsensehostAssociationsessionsStart_598356,
    base: "/adsensehost/v4.1", url: url_AdsensehostAssociationsessionsStart_598357,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAssociationsessionsVerify_598372 = ref object of OpenApiRestCall_597424
proc url_AdsensehostAssociationsessionsVerify_598374(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsensehostAssociationsessionsVerify_598373(path: JsonNode;
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
  var valid_598375 = query.getOrDefault("token")
  valid_598375 = validateParameter(valid_598375, JString, required = true,
                                 default = nil)
  if valid_598375 != nil:
    section.add "token", valid_598375
  var valid_598376 = query.getOrDefault("fields")
  valid_598376 = validateParameter(valid_598376, JString, required = false,
                                 default = nil)
  if valid_598376 != nil:
    section.add "fields", valid_598376
  var valid_598377 = query.getOrDefault("quotaUser")
  valid_598377 = validateParameter(valid_598377, JString, required = false,
                                 default = nil)
  if valid_598377 != nil:
    section.add "quotaUser", valid_598377
  var valid_598378 = query.getOrDefault("alt")
  valid_598378 = validateParameter(valid_598378, JString, required = false,
                                 default = newJString("json"))
  if valid_598378 != nil:
    section.add "alt", valid_598378
  var valid_598379 = query.getOrDefault("oauth_token")
  valid_598379 = validateParameter(valid_598379, JString, required = false,
                                 default = nil)
  if valid_598379 != nil:
    section.add "oauth_token", valid_598379
  var valid_598380 = query.getOrDefault("userIp")
  valid_598380 = validateParameter(valid_598380, JString, required = false,
                                 default = nil)
  if valid_598380 != nil:
    section.add "userIp", valid_598380
  var valid_598381 = query.getOrDefault("key")
  valid_598381 = validateParameter(valid_598381, JString, required = false,
                                 default = nil)
  if valid_598381 != nil:
    section.add "key", valid_598381
  var valid_598382 = query.getOrDefault("prettyPrint")
  valid_598382 = validateParameter(valid_598382, JBool, required = false,
                                 default = newJBool(true))
  if valid_598382 != nil:
    section.add "prettyPrint", valid_598382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598383: Call_AdsensehostAssociationsessionsVerify_598372;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verify an association session after the association callback returns from AdSense signup.
  ## 
  let valid = call_598383.validator(path, query, header, formData, body)
  let scheme = call_598383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598383.url(scheme.get, call_598383.host, call_598383.base,
                         call_598383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598383, url, valid)

proc call*(call_598384: Call_AdsensehostAssociationsessionsVerify_598372;
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
  var query_598385 = newJObject()
  add(query_598385, "token", newJString(token))
  add(query_598385, "fields", newJString(fields))
  add(query_598385, "quotaUser", newJString(quotaUser))
  add(query_598385, "alt", newJString(alt))
  add(query_598385, "oauth_token", newJString(oauthToken))
  add(query_598385, "userIp", newJString(userIp))
  add(query_598385, "key", newJString(key))
  add(query_598385, "prettyPrint", newJBool(prettyPrint))
  result = call_598384.call(nil, query_598385, nil, nil, nil)

var adsensehostAssociationsessionsVerify* = Call_AdsensehostAssociationsessionsVerify_598372(
    name: "adsensehostAssociationsessionsVerify", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/associationsessions/verify",
    validator: validate_AdsensehostAssociationsessionsVerify_598373,
    base: "/adsensehost/v4.1", url: url_AdsensehostAssociationsessionsVerify_598374,
    schemes: {Scheme.Https})
type
  Call_AdsensehostReportsGenerate_598386 = ref object of OpenApiRestCall_597424
proc url_AdsensehostReportsGenerate_598388(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsensehostReportsGenerate_598387(path: JsonNode; query: JsonNode;
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
  var valid_598389 = query.getOrDefault("locale")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = nil)
  if valid_598389 != nil:
    section.add "locale", valid_598389
  var valid_598390 = query.getOrDefault("fields")
  valid_598390 = validateParameter(valid_598390, JString, required = false,
                                 default = nil)
  if valid_598390 != nil:
    section.add "fields", valid_598390
  var valid_598391 = query.getOrDefault("quotaUser")
  valid_598391 = validateParameter(valid_598391, JString, required = false,
                                 default = nil)
  if valid_598391 != nil:
    section.add "quotaUser", valid_598391
  var valid_598392 = query.getOrDefault("alt")
  valid_598392 = validateParameter(valid_598392, JString, required = false,
                                 default = newJString("json"))
  if valid_598392 != nil:
    section.add "alt", valid_598392
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_598393 = query.getOrDefault("endDate")
  valid_598393 = validateParameter(valid_598393, JString, required = true,
                                 default = nil)
  if valid_598393 != nil:
    section.add "endDate", valid_598393
  var valid_598394 = query.getOrDefault("startDate")
  valid_598394 = validateParameter(valid_598394, JString, required = true,
                                 default = nil)
  if valid_598394 != nil:
    section.add "startDate", valid_598394
  var valid_598395 = query.getOrDefault("sort")
  valid_598395 = validateParameter(valid_598395, JArray, required = false,
                                 default = nil)
  if valid_598395 != nil:
    section.add "sort", valid_598395
  var valid_598396 = query.getOrDefault("oauth_token")
  valid_598396 = validateParameter(valid_598396, JString, required = false,
                                 default = nil)
  if valid_598396 != nil:
    section.add "oauth_token", valid_598396
  var valid_598397 = query.getOrDefault("userIp")
  valid_598397 = validateParameter(valid_598397, JString, required = false,
                                 default = nil)
  if valid_598397 != nil:
    section.add "userIp", valid_598397
  var valid_598398 = query.getOrDefault("maxResults")
  valid_598398 = validateParameter(valid_598398, JInt, required = false, default = nil)
  if valid_598398 != nil:
    section.add "maxResults", valid_598398
  var valid_598399 = query.getOrDefault("key")
  valid_598399 = validateParameter(valid_598399, JString, required = false,
                                 default = nil)
  if valid_598399 != nil:
    section.add "key", valid_598399
  var valid_598400 = query.getOrDefault("metric")
  valid_598400 = validateParameter(valid_598400, JArray, required = false,
                                 default = nil)
  if valid_598400 != nil:
    section.add "metric", valid_598400
  var valid_598401 = query.getOrDefault("prettyPrint")
  valid_598401 = validateParameter(valid_598401, JBool, required = false,
                                 default = newJBool(true))
  if valid_598401 != nil:
    section.add "prettyPrint", valid_598401
  var valid_598402 = query.getOrDefault("dimension")
  valid_598402 = validateParameter(valid_598402, JArray, required = false,
                                 default = nil)
  if valid_598402 != nil:
    section.add "dimension", valid_598402
  var valid_598403 = query.getOrDefault("filter")
  valid_598403 = validateParameter(valid_598403, JArray, required = false,
                                 default = nil)
  if valid_598403 != nil:
    section.add "filter", valid_598403
  var valid_598404 = query.getOrDefault("startIndex")
  valid_598404 = validateParameter(valid_598404, JInt, required = false, default = nil)
  if valid_598404 != nil:
    section.add "startIndex", valid_598404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598405: Call_AdsensehostReportsGenerate_598386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_598405.validator(path, query, header, formData, body)
  let scheme = call_598405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598405.url(scheme.get, call_598405.host, call_598405.base,
                         call_598405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598405, url, valid)

proc call*(call_598406: Call_AdsensehostReportsGenerate_598386; endDate: string;
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
  var query_598407 = newJObject()
  add(query_598407, "locale", newJString(locale))
  add(query_598407, "fields", newJString(fields))
  add(query_598407, "quotaUser", newJString(quotaUser))
  add(query_598407, "alt", newJString(alt))
  add(query_598407, "endDate", newJString(endDate))
  add(query_598407, "startDate", newJString(startDate))
  if sort != nil:
    query_598407.add "sort", sort
  add(query_598407, "oauth_token", newJString(oauthToken))
  add(query_598407, "userIp", newJString(userIp))
  add(query_598407, "maxResults", newJInt(maxResults))
  add(query_598407, "key", newJString(key))
  if metric != nil:
    query_598407.add "metric", metric
  add(query_598407, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_598407.add "dimension", dimension
  if filter != nil:
    query_598407.add "filter", filter
  add(query_598407, "startIndex", newJInt(startIndex))
  result = call_598406.call(nil, query_598407, nil, nil, nil)

var adsensehostReportsGenerate* = Call_AdsensehostReportsGenerate_598386(
    name: "adsensehostReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdsensehostReportsGenerate_598387,
    base: "/adsensehost/v4.1", url: url_AdsensehostReportsGenerate_598388,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
