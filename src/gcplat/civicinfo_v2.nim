
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Civic Information
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides polling places, early vote locations, contest data, election officials, and government representatives for U.S. residential addresses.
## 
## https://developers.google.com/civic-information
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

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
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
  gcpServiceName = "civicinfo"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CivicinfoDivisionsSearch_579634 = ref object of OpenApiRestCall_579364
proc url_CivicinfoDivisionsSearch_579636(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CivicinfoDivisionsSearch_579635(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches for political divisions by their natural name or OCD ID.
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
  ##   query: JString
  ##        : The search query. Queries can cover any parts of a OCD ID or a human readable division name. All words given in the query are treated as required patterns. In addition to that, most query operators of the Apache Lucene library are supported. See http://lucene.apache.org/core/2_9_4/queryparsersyntax.html
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579748 = query.getOrDefault("key")
  valid_579748 = validateParameter(valid_579748, JString, required = false,
                                 default = nil)
  if valid_579748 != nil:
    section.add "key", valid_579748
  var valid_579762 = query.getOrDefault("prettyPrint")
  valid_579762 = validateParameter(valid_579762, JBool, required = false,
                                 default = newJBool(true))
  if valid_579762 != nil:
    section.add "prettyPrint", valid_579762
  var valid_579763 = query.getOrDefault("oauth_token")
  valid_579763 = validateParameter(valid_579763, JString, required = false,
                                 default = nil)
  if valid_579763 != nil:
    section.add "oauth_token", valid_579763
  var valid_579764 = query.getOrDefault("alt")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = newJString("json"))
  if valid_579764 != nil:
    section.add "alt", valid_579764
  var valid_579765 = query.getOrDefault("userIp")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = nil)
  if valid_579765 != nil:
    section.add "userIp", valid_579765
  var valid_579766 = query.getOrDefault("quotaUser")
  valid_579766 = validateParameter(valid_579766, JString, required = false,
                                 default = nil)
  if valid_579766 != nil:
    section.add "quotaUser", valid_579766
  var valid_579767 = query.getOrDefault("query")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = nil)
  if valid_579767 != nil:
    section.add "query", valid_579767
  var valid_579768 = query.getOrDefault("fields")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = nil)
  if valid_579768 != nil:
    section.add "fields", valid_579768
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

proc call*(call_579792: Call_CivicinfoDivisionsSearch_579634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches for political divisions by their natural name or OCD ID.
  ## 
  let valid = call_579792.validator(path, query, header, formData, body)
  let scheme = call_579792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579792.url(scheme.get, call_579792.host, call_579792.base,
                         call_579792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579792, url, valid)

proc call*(call_579863: Call_CivicinfoDivisionsSearch_579634; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          query: string = ""; fields: string = ""): Recallable =
  ## civicinfoDivisionsSearch
  ## Searches for political divisions by their natural name or OCD ID.
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
  ##   body: JObject
  ##   query: string
  ##        : The search query. Queries can cover any parts of a OCD ID or a human readable division name. All words given in the query are treated as required patterns. In addition to that, most query operators of the Apache Lucene library are supported. See http://lucene.apache.org/core/2_9_4/queryparsersyntax.html
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579864 = newJObject()
  var body_579866 = newJObject()
  add(query_579864, "key", newJString(key))
  add(query_579864, "prettyPrint", newJBool(prettyPrint))
  add(query_579864, "oauth_token", newJString(oauthToken))
  add(query_579864, "alt", newJString(alt))
  add(query_579864, "userIp", newJString(userIp))
  add(query_579864, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579866 = body
  add(query_579864, "query", newJString(query))
  add(query_579864, "fields", newJString(fields))
  result = call_579863.call(nil, query_579864, nil, nil, body_579866)

var civicinfoDivisionsSearch* = Call_CivicinfoDivisionsSearch_579634(
    name: "civicinfoDivisionsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/divisions",
    validator: validate_CivicinfoDivisionsSearch_579635, base: "/civicinfo/v2",
    url: url_CivicinfoDivisionsSearch_579636, schemes: {Scheme.Https})
type
  Call_CivicinfoElectionsElectionQuery_579905 = ref object of OpenApiRestCall_579364
proc url_CivicinfoElectionsElectionQuery_579907(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CivicinfoElectionsElectionQuery_579906(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List of available elections to query.
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579908 = query.getOrDefault("key")
  valid_579908 = validateParameter(valid_579908, JString, required = false,
                                 default = nil)
  if valid_579908 != nil:
    section.add "key", valid_579908
  var valid_579909 = query.getOrDefault("prettyPrint")
  valid_579909 = validateParameter(valid_579909, JBool, required = false,
                                 default = newJBool(true))
  if valid_579909 != nil:
    section.add "prettyPrint", valid_579909
  var valid_579910 = query.getOrDefault("oauth_token")
  valid_579910 = validateParameter(valid_579910, JString, required = false,
                                 default = nil)
  if valid_579910 != nil:
    section.add "oauth_token", valid_579910
  var valid_579911 = query.getOrDefault("alt")
  valid_579911 = validateParameter(valid_579911, JString, required = false,
                                 default = newJString("json"))
  if valid_579911 != nil:
    section.add "alt", valid_579911
  var valid_579912 = query.getOrDefault("userIp")
  valid_579912 = validateParameter(valid_579912, JString, required = false,
                                 default = nil)
  if valid_579912 != nil:
    section.add "userIp", valid_579912
  var valid_579913 = query.getOrDefault("quotaUser")
  valid_579913 = validateParameter(valid_579913, JString, required = false,
                                 default = nil)
  if valid_579913 != nil:
    section.add "quotaUser", valid_579913
  var valid_579914 = query.getOrDefault("fields")
  valid_579914 = validateParameter(valid_579914, JString, required = false,
                                 default = nil)
  if valid_579914 != nil:
    section.add "fields", valid_579914
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

proc call*(call_579916: Call_CivicinfoElectionsElectionQuery_579905;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List of available elections to query.
  ## 
  let valid = call_579916.validator(path, query, header, formData, body)
  let scheme = call_579916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579916.url(scheme.get, call_579916.host, call_579916.base,
                         call_579916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579916, url, valid)

proc call*(call_579917: Call_CivicinfoElectionsElectionQuery_579905;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## civicinfoElectionsElectionQuery
  ## List of available elections to query.
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579918 = newJObject()
  var body_579919 = newJObject()
  add(query_579918, "key", newJString(key))
  add(query_579918, "prettyPrint", newJBool(prettyPrint))
  add(query_579918, "oauth_token", newJString(oauthToken))
  add(query_579918, "alt", newJString(alt))
  add(query_579918, "userIp", newJString(userIp))
  add(query_579918, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579919 = body
  add(query_579918, "fields", newJString(fields))
  result = call_579917.call(nil, query_579918, nil, nil, body_579919)

var civicinfoElectionsElectionQuery* = Call_CivicinfoElectionsElectionQuery_579905(
    name: "civicinfoElectionsElectionQuery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/elections",
    validator: validate_CivicinfoElectionsElectionQuery_579906,
    base: "/civicinfo/v2", url: url_CivicinfoElectionsElectionQuery_579907,
    schemes: {Scheme.Https})
type
  Call_CivicinfoRepresentativesRepresentativeInfoByAddress_579920 = ref object of OpenApiRestCall_579364
proc url_CivicinfoRepresentativesRepresentativeInfoByAddress_579922(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CivicinfoRepresentativesRepresentativeInfoByAddress_579921(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Looks up political geography and representative information for a single address.
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
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeOffices: JBool
  ##                 : Whether to return information about offices and officials. If false, only the top-level district information will be returned.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   address: JString
  ##          : The address to look up. May only be specified if the field ocdId is not given in the URL.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579923 = query.getOrDefault("key")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "key", valid_579923
  var valid_579924 = query.getOrDefault("prettyPrint")
  valid_579924 = validateParameter(valid_579924, JBool, required = false,
                                 default = newJBool(true))
  if valid_579924 != nil:
    section.add "prettyPrint", valid_579924
  var valid_579925 = query.getOrDefault("oauth_token")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = nil)
  if valid_579925 != nil:
    section.add "oauth_token", valid_579925
  var valid_579926 = query.getOrDefault("roles")
  valid_579926 = validateParameter(valid_579926, JArray, required = false,
                                 default = nil)
  if valid_579926 != nil:
    section.add "roles", valid_579926
  var valid_579927 = query.getOrDefault("alt")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = newJString("json"))
  if valid_579927 != nil:
    section.add "alt", valid_579927
  var valid_579928 = query.getOrDefault("userIp")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "userIp", valid_579928
  var valid_579929 = query.getOrDefault("quotaUser")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "quotaUser", valid_579929
  var valid_579930 = query.getOrDefault("includeOffices")
  valid_579930 = validateParameter(valid_579930, JBool, required = false,
                                 default = newJBool(true))
  if valid_579930 != nil:
    section.add "includeOffices", valid_579930
  var valid_579931 = query.getOrDefault("levels")
  valid_579931 = validateParameter(valid_579931, JArray, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "levels", valid_579931
  var valid_579932 = query.getOrDefault("address")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "address", valid_579932
  var valid_579933 = query.getOrDefault("fields")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "fields", valid_579933
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

proc call*(call_579935: Call_CivicinfoRepresentativesRepresentativeInfoByAddress_579920;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up political geography and representative information for a single address.
  ## 
  let valid = call_579935.validator(path, query, header, formData, body)
  let scheme = call_579935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579935.url(scheme.get, call_579935.host, call_579935.base,
                         call_579935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579935, url, valid)

proc call*(call_579936: Call_CivicinfoRepresentativesRepresentativeInfoByAddress_579920;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          roles: JsonNode = nil; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; includeOffices: bool = true; levels: JsonNode = nil;
          body: JsonNode = nil; address: string = ""; fields: string = ""): Recallable =
  ## civicinfoRepresentativesRepresentativeInfoByAddress
  ## Looks up political geography and representative information for a single address.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeOffices: bool
  ##                 : Whether to return information about offices and officials. If false, only the top-level district information will be returned.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   body: JObject
  ##   address: string
  ##          : The address to look up. May only be specified if the field ocdId is not given in the URL.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579937 = newJObject()
  var body_579938 = newJObject()
  add(query_579937, "key", newJString(key))
  add(query_579937, "prettyPrint", newJBool(prettyPrint))
  add(query_579937, "oauth_token", newJString(oauthToken))
  if roles != nil:
    query_579937.add "roles", roles
  add(query_579937, "alt", newJString(alt))
  add(query_579937, "userIp", newJString(userIp))
  add(query_579937, "quotaUser", newJString(quotaUser))
  add(query_579937, "includeOffices", newJBool(includeOffices))
  if levels != nil:
    query_579937.add "levels", levels
  if body != nil:
    body_579938 = body
  add(query_579937, "address", newJString(address))
  add(query_579937, "fields", newJString(fields))
  result = call_579936.call(nil, query_579937, nil, nil, body_579938)

var civicinfoRepresentativesRepresentativeInfoByAddress* = Call_CivicinfoRepresentativesRepresentativeInfoByAddress_579920(
    name: "civicinfoRepresentativesRepresentativeInfoByAddress",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/representatives",
    validator: validate_CivicinfoRepresentativesRepresentativeInfoByAddress_579921,
    base: "/civicinfo/v2",
    url: url_CivicinfoRepresentativesRepresentativeInfoByAddress_579922,
    schemes: {Scheme.Https})
type
  Call_CivicinfoRepresentativesRepresentativeInfoByDivision_579939 = ref object of OpenApiRestCall_579364
proc url_CivicinfoRepresentativesRepresentativeInfoByDivision_579941(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "ocdId" in path, "`ocdId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/representatives/"),
               (kind: VariableSegment, value: "ocdId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CivicinfoRepresentativesRepresentativeInfoByDivision_579940(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Looks up representative information for a single geographic division.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ocdId: JString (required)
  ##        : The Open Civic Data division identifier of the division to look up.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ocdId` field"
  var valid_579956 = path.getOrDefault("ocdId")
  valid_579956 = validateParameter(valid_579956, JString, required = true,
                                 default = nil)
  if valid_579956 != nil:
    section.add "ocdId", valid_579956
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   recursive: JBool
  ##            : If true, information about all divisions contained in the division requested will be included as well. For example, if querying ocd-division/country:us/district:dc, this would also return all DC's wards and ANCs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579957 = query.getOrDefault("key")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "key", valid_579957
  var valid_579958 = query.getOrDefault("prettyPrint")
  valid_579958 = validateParameter(valid_579958, JBool, required = false,
                                 default = newJBool(true))
  if valid_579958 != nil:
    section.add "prettyPrint", valid_579958
  var valid_579959 = query.getOrDefault("oauth_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "oauth_token", valid_579959
  var valid_579960 = query.getOrDefault("roles")
  valid_579960 = validateParameter(valid_579960, JArray, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "roles", valid_579960
  var valid_579961 = query.getOrDefault("recursive")
  valid_579961 = validateParameter(valid_579961, JBool, required = false, default = nil)
  if valid_579961 != nil:
    section.add "recursive", valid_579961
  var valid_579962 = query.getOrDefault("alt")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = newJString("json"))
  if valid_579962 != nil:
    section.add "alt", valid_579962
  var valid_579963 = query.getOrDefault("userIp")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "userIp", valid_579963
  var valid_579964 = query.getOrDefault("quotaUser")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "quotaUser", valid_579964
  var valid_579965 = query.getOrDefault("levels")
  valid_579965 = validateParameter(valid_579965, JArray, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "levels", valid_579965
  var valid_579966 = query.getOrDefault("fields")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "fields", valid_579966
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

proc call*(call_579968: Call_CivicinfoRepresentativesRepresentativeInfoByDivision_579939;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up representative information for a single geographic division.
  ## 
  let valid = call_579968.validator(path, query, header, formData, body)
  let scheme = call_579968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579968.url(scheme.get, call_579968.host, call_579968.base,
                         call_579968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579968, url, valid)

proc call*(call_579969: Call_CivicinfoRepresentativesRepresentativeInfoByDivision_579939;
          ocdId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; roles: JsonNode = nil; recursive: bool = false;
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          levels: JsonNode = nil; body: JsonNode = nil; fields: string = ""): Recallable =
  ## civicinfoRepresentativesRepresentativeInfoByDivision
  ## Looks up representative information for a single geographic division.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   roles: JArray
  ##        : A list of office roles to filter by. Only offices fulfilling one of these roles will be returned. Divisions that don't contain a matching office will not be returned.
  ##   recursive: bool
  ##            : If true, information about all divisions contained in the division requested will be included as well. For example, if querying ocd-division/country:us/district:dc, this would also return all DC's wards and ANCs.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   ocdId: string (required)
  ##        : The Open Civic Data division identifier of the division to look up.
  ##   levels: JArray
  ##         : A list of office levels to filter by. Only offices that serve at least one of these levels will be returned. Divisions that don't contain a matching office will not be returned.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579970 = newJObject()
  var query_579971 = newJObject()
  var body_579972 = newJObject()
  add(query_579971, "key", newJString(key))
  add(query_579971, "prettyPrint", newJBool(prettyPrint))
  add(query_579971, "oauth_token", newJString(oauthToken))
  if roles != nil:
    query_579971.add "roles", roles
  add(query_579971, "recursive", newJBool(recursive))
  add(query_579971, "alt", newJString(alt))
  add(query_579971, "userIp", newJString(userIp))
  add(query_579971, "quotaUser", newJString(quotaUser))
  add(path_579970, "ocdId", newJString(ocdId))
  if levels != nil:
    query_579971.add "levels", levels
  if body != nil:
    body_579972 = body
  add(query_579971, "fields", newJString(fields))
  result = call_579969.call(path_579970, query_579971, nil, nil, body_579972)

var civicinfoRepresentativesRepresentativeInfoByDivision* = Call_CivicinfoRepresentativesRepresentativeInfoByDivision_579939(
    name: "civicinfoRepresentativesRepresentativeInfoByDivision",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/representatives/{ocdId}",
    validator: validate_CivicinfoRepresentativesRepresentativeInfoByDivision_579940,
    base: "/civicinfo/v2",
    url: url_CivicinfoRepresentativesRepresentativeInfoByDivision_579941,
    schemes: {Scheme.Https})
type
  Call_CivicinfoElectionsVoterInfoQuery_579973 = ref object of OpenApiRestCall_579364
proc url_CivicinfoElectionsVoterInfoQuery_579975(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CivicinfoElectionsVoterInfoQuery_579974(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Looks up information relevant to a voter based on the voter's registered address.
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
  ##   officialOnly: JBool
  ##               : If set to true, only data from official state sources will be returned.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   returnAllAvailableData: JBool
  ##                         : If set to true, the query will return the success codeand include any partial information when it is unable to determine a matching address or unable to determine the election for electionId=0 queries.
  ##   address: JString (required)
  ##          : The registered address of the voter to look up.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   electionId: JString
  ##             : The unique ID of the election to look up. A list of election IDs can be obtained at https://www.googleapis.com/civicinfo/{version}/electionsIf no election ID is specified in the query and there is more than one election with data for the given voter, the additional elections are provided in the otherElections response field.
  section = newJObject()
  var valid_579976 = query.getOrDefault("key")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "key", valid_579976
  var valid_579977 = query.getOrDefault("prettyPrint")
  valid_579977 = validateParameter(valid_579977, JBool, required = false,
                                 default = newJBool(true))
  if valid_579977 != nil:
    section.add "prettyPrint", valid_579977
  var valid_579978 = query.getOrDefault("oauth_token")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "oauth_token", valid_579978
  var valid_579979 = query.getOrDefault("officialOnly")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(false))
  if valid_579979 != nil:
    section.add "officialOnly", valid_579979
  var valid_579980 = query.getOrDefault("alt")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = newJString("json"))
  if valid_579980 != nil:
    section.add "alt", valid_579980
  var valid_579981 = query.getOrDefault("userIp")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "userIp", valid_579981
  var valid_579982 = query.getOrDefault("quotaUser")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "quotaUser", valid_579982
  var valid_579983 = query.getOrDefault("returnAllAvailableData")
  valid_579983 = validateParameter(valid_579983, JBool, required = false,
                                 default = newJBool(false))
  if valid_579983 != nil:
    section.add "returnAllAvailableData", valid_579983
  assert query != nil, "query argument is necessary due to required `address` field"
  var valid_579984 = query.getOrDefault("address")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "address", valid_579984
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("electionId")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = newJString("0"))
  if valid_579986 != nil:
    section.add "electionId", valid_579986
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

proc call*(call_579988: Call_CivicinfoElectionsVoterInfoQuery_579973;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up information relevant to a voter based on the voter's registered address.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_CivicinfoElectionsVoterInfoQuery_579973;
          address: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; officialOnly: bool = false; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          returnAllAvailableData: bool = false; body: JsonNode = nil;
          fields: string = ""; electionId: string = "0"): Recallable =
  ## civicinfoElectionsVoterInfoQuery
  ## Looks up information relevant to a voter based on the voter's registered address.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   officialOnly: bool
  ##               : If set to true, only data from official state sources will be returned.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   returnAllAvailableData: bool
  ##                         : If set to true, the query will return the success codeand include any partial information when it is unable to determine a matching address or unable to determine the election for electionId=0 queries.
  ##   body: JObject
  ##   address: string (required)
  ##          : The registered address of the voter to look up.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   electionId: string
  ##             : The unique ID of the election to look up. A list of election IDs can be obtained at https://www.googleapis.com/civicinfo/{version}/electionsIf no election ID is specified in the query and there is more than one election with data for the given voter, the additional elections are provided in the otherElections response field.
  var query_579990 = newJObject()
  var body_579991 = newJObject()
  add(query_579990, "key", newJString(key))
  add(query_579990, "prettyPrint", newJBool(prettyPrint))
  add(query_579990, "oauth_token", newJString(oauthToken))
  add(query_579990, "officialOnly", newJBool(officialOnly))
  add(query_579990, "alt", newJString(alt))
  add(query_579990, "userIp", newJString(userIp))
  add(query_579990, "quotaUser", newJString(quotaUser))
  add(query_579990, "returnAllAvailableData", newJBool(returnAllAvailableData))
  if body != nil:
    body_579991 = body
  add(query_579990, "address", newJString(address))
  add(query_579990, "fields", newJString(fields))
  add(query_579990, "electionId", newJString(electionId))
  result = call_579989.call(nil, query_579990, nil, nil, body_579991)

var civicinfoElectionsVoterInfoQuery* = Call_CivicinfoElectionsVoterInfoQuery_579973(
    name: "civicinfoElectionsVoterInfoQuery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/voterinfo",
    validator: validate_CivicinfoElectionsVoterInfoQuery_579974,
    base: "/civicinfo/v2", url: url_CivicinfoElectionsVoterInfoQuery_579975,
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
